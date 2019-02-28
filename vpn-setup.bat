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
set /p VPN_USER_NAME="VPNのユーザー名を入力してください (suzuki): "
set /p VPN_USER_PASSWORD="VPNのパスワードを入力してください: "
rem variable set
set VPN_LABEL=あなたの団体VPN^(%VPN_USER_NAME%^)
set VPN_LABEL_PS=あなたの団体VPN`(%VPN_USER_NAME%`)
set VPN_SERVER_ADDRESS=your.vpnserver.comm
set VPN_TYPE=L2tp
set VPN_PRESHARED_KEY=YourPresharedKey
rem Accepted values: Pap, Chap, MSChapv2, Eap, MachineCertificate
set VPN_AUTH_PROTOCOL=Pap
rem Accepted values: NoEncryption, Optional, Required, Maximum, Custom
set ENCRYPTION_LEVEL=Optional
set CONNECTION_TEST_NAME=接続試行に使うサーバー
set CONNECTION_TEST_ADDRESS=xxx.xxx.xxx.xxx
rem feedback input
echo ------------------------------------------------------
echo VPNを設定します
echo ------------------------------------------------------
echo 接続名： %VPN_LABEL%
echo サーバー名： %VPN_SERVER_ADDRESS%
echo VPNの種類： 事前共有キーを使った L2TP/IPsec
echo 事前共有キー： %VPN_PRESHARED_KEY%
echo ユーザー名： %VPN_USER_NAME%
echo パスワード： **********

echo ------------------------------------------------------
powershell Add-VpnConnection -Name "%VPN_LABEL_PS%" -ServerAddress %VPN_SERVER_ADDRESS% -TunnelType "%VPN_TYPE%" -EncryptionLevel "%ENCRYPTION_LEVEL%" -AuthenticationMethod %VPN_AUTH_PROTOCOL% -SplitTunneling -L2tpPsk %VPN_PRESHARED_KEY% -Force -RememberCredential -PassThru
echo ------------------------------------------------------
echo %VPN_LABEL%に接続します
echo ------------------------------------------------------
TIMEOUT /T 3
rasdial "%VPN_LABEL%" /disconnect
rasdial "%VPN_LABEL%" "%VPN_USER_NAME%" "%VPN_USER_PASSWORD%"
echo ------------------------------------------------------
echo %CONNECTION_TEST_NAME%への通信テストを行います
echo ------------------------------------------------------
TIMEOUT /T 3
ping %CONNECTION_TEST_ADDRESS%
echo ------------------------------------------------------
echo %VPN_LABEL%を切断します
echo ------------------------------------------------------
TIMEOUT /T 3
rasdial "%VPN_LABEL%" /disconnect
echo ------------------------------------------------------
echo VPNの設定が完了しました
echo ------------------------------------------------------
pause
