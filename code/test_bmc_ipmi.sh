#!/bin/bash
# Tests IPMI spécifiques pour BMC Aspeed AST2600 Simulator
# Usage: ./test_bmc_ipmi.sh [BMC_IP]

BMC_IP=10.0.1.46
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔧 === TESTS IPMI BMC ASPEED AST2600 ===${NC}"
echo "BMC IP: $BMC_IP"
echo ""

if ! command -v ipmitool >/dev/null 2>&1; then
    echo -e "${RED}❌ ipmitool non installé. Installation requise:${NC}"
    echo "Ubuntu/Debian: sudo apt install ipmitool"
    echo "CentOS/RHEL: sudo yum install ipmitool"
    exit 1
fi

# Test 1: Device ID
echo -n "🔍 Test Device ID... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus mc info >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
    DEVICE_INFO=$(timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus mc info 2>/dev/null)
    echo "   Manufacturer: $(echo "$DEVICE_INFO" | grep "Manufacturer Name" | cut -d: -f2 | xargs)"
    echo "   Product: $(echo "$DEVICE_INFO" | grep "Product Name" | cut -d: -f2 | xargs)"
    echo "   Firmware: $(echo "$DEVICE_INFO" | grep "Firmware Revision" | cut -d: -f2 | xargs)"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 2: Chassis Status
echo -n "🔍 Test Chassis Status... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus chassis status >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
    CHASSIS_STATUS=$(timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus chassis status 2>/dev/null)
    echo "   Power: $(echo "$CHASSIS_STATUS" | grep "System Power" | cut -d: -f2 | xargs)"
    echo "   State: $(echo "$CHASSIS_STATUS" | grep "Power Restore" | cut -d: -f2 | xargs)"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 3: Power On
echo -n "🔍 Test Power On... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus chassis power on >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 4: Power Status after On
sleep 2
echo -n "🔍 Test Power Status après On... "
POWER_STATE=$(timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus chassis power status 2>/dev/null | grep -o "on\|off")
if [[ "$POWER_STATE" == "on" ]]; then
    echo -e "${GREEN}✅ PASS${NC} (Power: $POWER_STATE)"
else
    echo -e "${RED}❌ FAIL${NC} (Power: $POWER_STATE)"
fi

# Test 5: Power Cycle
echo -n "🔍 Test Power Cycle... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus chassis power cycle >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 6: Power Off
echo -n "🔍 Test Power Off... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus chassis power off >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 7: SDR (Sensor Data Records)
echo -n "🔍 Test SDR Info... "
if timeout 15 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus sdr info >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
    SDR_INFO=$(timeout 15 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus sdr info 2>/dev/null)
    echo "   SDR Version: $(echo "$SDR_INFO" | grep "SDR Version" | cut -d: -f2 | xargs)"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 8: Sensor Reading
echo -n "🔍 Test Sensor Reading... "
if timeout 15 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus sensor reading 0x01 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test 9: FRU (Field Replaceable Unit)
echo -n "🔍 Test FRU Info... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus fru print >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC} (Normal - FRU non implémenté dans simulateur)"
fi

# Test 10: Self Test
echo -n "🔍 Test Self Test... "
if timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus mc selftest >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
    SELFTEST=$(timeout 10 ipmitool -H "$BMC_IP" -U admin -P admin -I lanplus mc selftest 2>/dev/null)
    echo "   Result: $SELFTEST"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

echo ""
echo -e "${YELLOW}🎯 Tests IPMI terminés !${NC}"
echo ""
echo -e "${YELLOW}💡 Commandes IPMI utiles:${NC}"
echo "ipmitool -H $BMC_IP -U admin -P admin -I lanplus mc info"
echo "ipmitool -H $BMC_IP -U admin -P admin -I lanplus chassis status"
echo "ipmitool -H $BMC_IP -U admin -P admin -I lanplus chassis power on|off|cycle"
echo "ipmitool -H $BMC_IP -U admin -P admin -I lanplus sdr list"
echo "ipmitool -H $BMC_IP -U admin -P admin -I lanplus sel list"
