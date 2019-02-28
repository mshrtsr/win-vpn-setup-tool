@echo off
setlocal
rem init
echo ------------------------------------------------------
echo VPN Setting tool
echo (c) 2019 Masaharu TASHIRO. All rights reserved.
echo ------------------------------------------------------
echo;
set VPN_USER_NAME=
set VPN_USER_PASSWORD=
rem user input
set /p VPN_USER_NAME="VPN username (c.f. suzuki): "
set /p VPN_USER_PASSWORD="VPN password: "
rem variable set
set VPN_LABEL=YourOrganization-VPN^(%VPN_USER_NAME%^)
set VPN_LABEL_PS=YourOrganization-VPN`(%VPN_USER_NAME%`)
set VPN_SERVER_ADDRESS=your.vpnserver.comm
set VPN_TYPE=L2tp
set VPN_PRESHARED_KEY=YourPresharedKey
rem Accepted values: Pap, Chap, MSChapv2, Eap, MachineCertificate
set VPN_AUTH_PROTOCOL=MSChapv2
rem Accepted values: NoEncryption, Optional, Required, Maximum, Custom
set ENCRYPTION_LEVEL=Optional
set CONNECTION_TEST_NAME=Your Connection Test Server
set CONNECTION_TEST_ADDRESS=xxx.xxx.xxx.xxx
rem feedback input
echo ------------------------------------------------------
echo Setting up VPN with following params
echo ------------------------------------------------------
echo connection label: %VPN_LABEL%
echo server address: %VPN_SERVER_ADDRESS%
echo VPN type: L2TP/IPsec(Preshared-key)
echo Preshared-key: %VPN_PRESHARED_KEY%
echo username: %VPN_USER_NAME%
echo password: **********

echo ------------------------------------------------------
powershell Add-VpnConnection -Name "%VPN_LABEL_PS%" -ServerAddress %VPN_SERVER_ADDRESS% -TunnelType "%VPN_TYPE%" -EncryptionLevel "%ENCRYPTION_LEVEL%" -AuthenticationMethod %VPN_AUTH_PROTOCOL% -SplitTunneling -L2tpPsk %VPN_PRESHARED_KEY% -Force -RememberCredential -PassThru
echo ------------------------------------------------------
echo Connect to %VPN_LABEL%
echo ------------------------------------------------------
TIMEOUT /T 3
rasdial "%VPN_LABEL%" /disconnect
rasdial "%VPN_LABEL%" "%VPN_USER_NAME%" "%VPN_USER_PASSWORD%"
echo ------------------------------------------------------
echo Trying to access %CONNECTION_TEST_NAME%
echo ------------------------------------------------------
TIMEOUT /T 3
ping %CONNECTION_TEST_ADDRESS%
echo ------------------------------------------------------
echo Disconnect from %VPN_LABEL%
echo ------------------------------------------------------
TIMEOUT /T 3
rasdial "%VPN_LABEL%" /disconnect
echo ------------------------------------------------------
echo VPN Setting completed
echo ------------------------------------------------------
pause
