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
set /p VPN_USER_NAME="VPN�̃��[�U�[������͂��Ă������� (suzuki): "
set /p VPN_USER_PASSWORD="VPN�̃p�X���[�h����͂��Ă�������: "
rem variable set
set VPN_LABEL=���Ȃ��̒c��VPN^(%VPN_USER_NAME%^)
set VPN_LABEL_PS=���Ȃ��̒c��VPN`(%VPN_USER_NAME%`)
set VPN_SERVER_ADDRESS=your.vpnserver.comm
set VPN_TYPE=L2tp
set VPN_PRESHARED_KEY=YourPresharedKey
rem Accepted values: Pap, Chap, MSChapv2, Eap, MachineCertificate
set VPN_AUTH_PROTOCOL=Pap
rem Accepted values: NoEncryption, Optional, Required, Maximum, Custom
set ENCRYPTION_LEVEL=Optional
set CONNECTION_TEST_NAME=�ڑ����s�Ɏg���T�[�o�[
set CONNECTION_TEST_ADDRESS=xxx.xxx.xxx.xxx
rem feedback input
echo ------------------------------------------------------
echo VPN��ݒ肵�܂�
echo ------------------------------------------------------
echo �ڑ����F %VPN_LABEL%
echo �T�[�o�[���F %VPN_SERVER_ADDRESS%
echo VPN�̎�ށF ���O���L�L�[���g���� L2TP/IPsec
echo ���O���L�L�[�F %VPN_PRESHARED_KEY%
echo ���[�U�[���F %VPN_USER_NAME%
echo �p�X���[�h�F **********

echo ------------------------------------------------------
powershell Add-VpnConnection -Name "%VPN_LABEL_PS%" -ServerAddress %VPN_SERVER_ADDRESS% -TunnelType "%VPN_TYPE%" -EncryptionLevel "%ENCRYPTION_LEVEL%" -AuthenticationMethod %VPN_AUTH_PROTOCOL% -SplitTunneling -L2tpPsk %VPN_PRESHARED_KEY% -Force -RememberCredential -PassThru
echo ------------------------------------------------------
echo %VPN_LABEL%�ɐڑ����܂�
echo ------------------------------------------------------
TIMEOUT /T 3
rasdial "%VPN_LABEL%" /disconnect
rasdial "%VPN_LABEL%" "%VPN_USER_NAME%" "%VPN_USER_PASSWORD%"
echo ------------------------------------------------------
echo %CONNECTION_TEST_NAME%�ւ̒ʐM�e�X�g���s���܂�
echo ------------------------------------------------------
TIMEOUT /T 3
ping %CONNECTION_TEST_ADDRESS%
echo ------------------------------------------------------
echo %VPN_LABEL%��ؒf���܂�
echo ------------------------------------------------------
TIMEOUT /T 3
rasdial "%VPN_LABEL%" /disconnect
echo ------------------------------------------------------
echo VPN�̐ݒ肪�������܂���
echo ------------------------------------------------------
pause
