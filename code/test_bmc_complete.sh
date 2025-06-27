#!/bin/bash
# Suite de tests complète pour BMC Aspeed AST2600 Simulator
# Usage: ./test_bmc_complete.sh [BMC_IP] [MQTT_IP]

set -e

# Configuration
BMC_IP=10.0.1.46
MQTT_IP=10.0.1.42

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Compteurs
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

echo -e "${BLUE}🧪 ===== BMC ASPEED AST2600 - SUITE DE TESTS COMPLÈTE =====${NC}"
echo -e "${YELLOW}📡 BMC IP: $BMC_IP${NC}"
echo -e "${YELLOW}📡 MQTT IP: $MQTT_IP${NC}"
echo ""

# Fonction de test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -n "🔍 Test $TESTS_TOTAL: $test_name... "
    
    if eval "$test_command" 2>/dev/null | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Fonction de test avec timeout
run_test_timeout() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    local timeout="${4:-10}"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -n "🔍 Test $TESTS_TOTAL: $test_name... "
    
    if timeout "$timeout" bash -c "$test_command" 2>/dev/null | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

echo -e "${YELLOW}🌐 === TESTS CONNECTIVITÉ ===${NC}"

# Test 1: Ping BMC
run_test "Ping BMC" "ping -c 1 $BMC_IP" "1 packets transmitted, 1 received"

# Test 2: Port 80 ouvert
run_test "Port 80 (HTTP)" "nc -z $BMC_IP 80" ""

# Test 3: Port 623 ouvert  
run_test "Port 623 (IPMI)" "nc -z $BMC_IP 623" ""

echo ""
echo -e "${YELLOW}🖥️ === TESTS INTERFACE WEB ===${NC}"

# Test 4: Interface web accessible
run_test "Interface web BMC" "curl -s http://$BMC_IP/" "BMC Aspeed AST2600"

# Test 5: API Servers
run_test "API /api/servers" "curl -s http://$BMC_IP/api/servers" "server_"

# Test 6: API BMC Status
run_test "API /api/bmc/status" "curl -s http://$BMC_IP/api/bmc/status" "bmc_info\|system_status"

# Test 7: API Energy
run_test "API /api/energy" "curl -s http://$BMC_IP/api/energy" "battery\|solar\|consumption"

echo ""
echo -e "${YELLOW}⚡ === TESTS CONTRÔLE SERVEURS ===${NC}"

# Test 8: Compter les serveurs
SERVER_COUNT=$(curl -s http://$BMC_IP/api/servers | jq '. | length' 2>/dev/null || echo "0")
run_test "12 serveurs simulés" "echo $SERVER_COUNT" "12"

# Test 9: Test power control
echo -n "🔍 Test 9: Power control server_01... "
POWER_RESULT=$(curl -s -X POST -H "Content-Type: application/json" \
    "http://$BMC_IP/api/server/server_01/power/power_on" \
    -d '{"force": false}' | jq -r '.success' 2>/dev/null)

if [[ "$POWER_RESULT" == "true" ]]; then
    echo -e "${GREEN}✅ PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}❌ FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

# Test 10: Test datacenter control
echo -n "🔍 Test 10: Datacenter control... "
DC_RESULT=$(curl -s -X POST -H "Content-Type: application/json" \
    "http://$BMC_IP/api/datacenter/status_all" | jq -r '.success' 2>/dev/null)

if [[ "$DC_RESULT" == "true" ]]; then
    echo -e "${GREEN}✅ PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}❌ FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

echo ""
echo -e "${YELLOW}🔧 === TESTS SERVICES SYSTÈME ===${NC}"

# Test 11-17: Services BMC
services=(
    "bmc-core-simulator:BMC Core"
    "bmc-web-simulator:BMC Web"
    "bmc-power-manager:BMC Power Manager"
    "bmc-sol-simulator:BMC SOL"
    "bmc-energy-integration:BMC Energy"
    "bmc-ipmi-simulator:BMC IPMI"
    "nginx:Nginx"
)

for service_info in "${services[@]}"; do
    service_name="${service_info%:*}"
    service_desc="${service_info#*:}"
    run_test "$service_desc service" "ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no $BMC_IP 'sudo systemctl is-active $service_name'" "active"
done

echo ""
echo -e "${YELLOW}📡 === TESTS MQTT/ÉNERGIE ===${NC}"

# Test 18: Test MQTT publishing (si mosquitto_pub disponible)
if command -v mosquitto_pub >/dev/null 2>&1; then
    echo -n "🔍 Test 18: MQTT publish test... "
    if mosquitto_pub -h "$MQTT_IP" -p 1883 -u iot -P iot123 \
        -t "test/bmc" -m "test" -q 1 >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
else
    echo "⚠️ Test 18: MQTT publish - mosquitto_pub non disponible"
fi

echo ""
echo -e "${YELLOW}⚙️ === TESTS FONCTIONNELS AVANCÉS ===${NC}"

# Test 19: Simulation batterie faible
if command -v mosquitto_pub >/dev/null 2>&1; then
    echo -n "🔍 Test 19: Simulation batterie faible... "
    
    # Compter serveurs avant
    SERVERS_BEFORE=$(curl -s http://$BMC_IP/api/servers | jq '[.[] | select(.power_state == "on")] | length' 2>/dev/null || echo "0")
    
    # Simuler batterie faible
    mosquitto_pub -h "$MQTT_IP" -p 1883 -u iot -P iot123 \
        -t "energy/battery/datacenter/status" \
        -m '{"charge_level": 15.0, "status": "critical", "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' >/dev/null 2>&1
    
    # Attendre réaction du BMC
    sleep 10
    
    # Compter serveurs après
    SERVERS_AFTER=$(curl -s http://$BMC_IP/api/servers | jq '[.[] | select(.power_state == "on")] | length' 2>/dev/null || echo "0")
    
    if [[ "$SERVERS_AFTER" -lt "$SERVERS_BEFORE" ]]; then
        echo -e "${GREEN}✅ PASS${NC} (${SERVERS_BEFORE}→${SERVERS_AFTER} serveurs)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC} (Pas de réaction auto-shutdown)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    # Remettre batterie normale
    mosquitto_pub -h "$MQTT_IP" -p 1883 -u iot -P iot123 \
        -t "energy/battery/datacenter/status" \
        -m '{"charge_level": 75.0, "status": "normal", "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' >/dev/null 2>&1
else
    echo "⚠️ Test 19: Simulation batterie - mosquitto_pub non disponible"
fi

# Test 20: Performance test
echo -n "🔍 Test 20: Performance API (100 requêtes)... "
START_TIME=$(date +%s.%N)
for i in {1..100}; do
    curl -s http://$BMC_IP/api/servers >/dev/null
done
END_TIME=$(date +%s.%N)
DURATION=$(echo "$END_TIME - $START_TIME" | bc -l 2>/dev/null || echo "5")

if (( $(echo "$DURATION < 10" | bc -l 2>/dev/null || echo "0") )); then
    echo -e "${GREEN}✅ PASS${NC} (${DURATION}s)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}❌ FAIL${NC} (${DURATION}s - trop lent)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_TOTAL=$((TESTS_TOTAL + 1))

echo ""
echo -e "${BLUE}📊 === RÉSULTATS FINAUX ===${NC}"
echo -e "Tests exécutés: $TESTS_TOTAL"
echo -e "${GREEN}✅ Réussis: $TESTS_PASSED${NC}"
echo -e "${RED}❌ Échoués: $TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}🎉 TOUS LES TESTS SONT PASSÉS ! BMC SIMULATEUR OPÉRATIONNEL 🎉${NC}"
    echo ""
    echo -e "${YELLOW}📋 Prochaines étapes recommandées:${NC}"
    echo "1. 📊 Intégration Grafana/monitoring"
    echo "2. ⚡ Tests scénarios énergétiques avancés"  
    echo "3. 🤖 Implémentation IA/ML pour optimisation"
    echo ""
    echo -e "${BLUE}🔗 Accès BMC:${NC}"
    echo "Web: http://$BMC_IP/"
    echo "API: http://$BMC_IP/api/servers"
    exit 0
else
    echo ""
    echo -e "${RED}⚠️ CERTAINS TESTS ONT ÉCHOUÉ${NC}"
    echo "Vérifiez les logs avec:"
    echo "ssh $BMC_IP 'sudo journalctl -u bmc-core-simulator -f'"
    echo "ssh $BMC_IP 'sudo journalctl -u bmc-web-simulator -f'"
    exit 1
fi
