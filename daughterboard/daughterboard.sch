EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L nice_nano:nice_nano U1
U 1 1 60CDDAE3
P 2650 2900
F 0 "U1" H 2650 3837 60  0000 C CNN
F 1 "nice_nano" H 2650 3731 60  0000 C CNN
F 2 "nice-nano-kicad:nice_nano" V 3700 400 60  0001 C CNN
F 3 "" V 3700 400 60  0001 C CNN
	1    2650 2900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x20_Female J1
U 1 1 60CDE4C5
P 5950 3050
F 0 "J1" H 5978 3026 50  0000 L CNN
F 1 "Conn_01x20_Female" H 5978 2935 50  0000 L CNN
F 2 "daughterboard:Molex2004850420" H 5950 3050 50  0001 C CNN
F 3 "~" H 5950 3050 50  0001 C CNN
	1    5950 3050
	1    0    0    -1  
$EndComp
Text GLabel 5750 2150 0    50   Input ~ 0
Row1
Text GLabel 5750 2250 0    50   Input ~ 0
Row2
Text GLabel 5750 2350 0    50   Input ~ 0
Row3
Text GLabel 5750 2450 0    50   Input ~ 0
Row4
Text GLabel 5750 2550 0    50   Input ~ 0
Row5
Text GLabel 5750 2650 0    50   Input ~ 0
Row6
Text GLabel 5750 2750 0    50   Input ~ 0
Row7
Text GLabel 5750 2850 0    50   Input ~ 0
Row8
Text GLabel 5750 2950 0    50   Input ~ 0
Column7
Text GLabel 5750 3050 0    50   Input ~ 0
Column6
Text GLabel 5750 3150 0    50   Input ~ 0
Column5
Text GLabel 5750 3250 0    50   Input ~ 0
Column4
Text GLabel 5750 3350 0    50   Input ~ 0
Column3
Text GLabel 5750 3450 0    50   Input ~ 0
Column2
Text GLabel 5750 3550 0    50   Input ~ 0
Column1
$Comp
L Connector_Generic:Conn_01x02 J2
U 1 1 60CE4F5A
P 5700 4500
F 0 "J2" H 5780 4492 50  0000 L CNN
F 1 "Conn_01x02" H 5780 4401 50  0000 L CNN
F 2 "Connector_JST:JST_PH_S2B-PH-K_1x02_P2.00mm_Horizontal" H 5700 4500 50  0001 C CNN
F 3 "~" H 5700 4500 50  0001 C CNN
	1    5700 4500
	1    0    0    -1  
$EndComp
Text GLabel 5500 4500 0    50   Input ~ 0
B+
Text GLabel 5500 4600 0    50   Input ~ 0
GND
Text GLabel 3350 2350 2    50   Input ~ 0
B+
Text GLabel 3350 2450 2    50   Input ~ 0
GND
Text GLabel 1950 2550 0    50   Input ~ 0
GND
Text GLabel 1950 2650 0    50   Input ~ 0
GND
Text GLabel 3350 3450 2    50   Input ~ 0
Row1
Text GLabel 3350 3350 2    50   Input ~ 0
Row2
Text GLabel 3350 3250 2    50   Input ~ 0
Row3
Text GLabel 3350 3150 2    50   Input ~ 0
Row4
Text GLabel 3350 3050 2    50   Input ~ 0
Row5
Text GLabel 3350 2950 2    50   Input ~ 0
Row6
Text GLabel 3350 2850 2    50   Input ~ 0
Row7
Text GLabel 3350 2750 2    50   Input ~ 0
Row8
Text GLabel 1950 2750 0    50   Input ~ 0
Column7
Text GLabel 1950 2850 0    50   Input ~ 0
Column6
Text GLabel 1950 2950 0    50   Input ~ 0
Column5
Text GLabel 1950 3050 0    50   Input ~ 0
Column4
Text GLabel 1950 3150 0    50   Input ~ 0
Column3
Text GLabel 1950 3250 0    50   Input ~ 0
Column2
Text GLabel 1950 3350 0    50   Input ~ 0
Column1
Text GLabel 5750 3750 0    50   Input ~ 0
GND
Text GLabel 5750 3850 0    50   Input ~ 0
GND
Text GLabel 5750 3950 0    50   Input ~ 0
GND
Text GLabel 5750 4050 0    50   Input ~ 0
GND
$Comp
L Switch:SW_SPST SW1
U 1 1 60D03565
P 3900 2550
F 0 "SW1" H 3900 2325 50  0000 C CNN
F 1 "SW_SPST" H 3900 2416 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SPST_Angled_PTS645Vx83-2LFS" H 3900 2550 50  0001 C CNN
F 3 "~" H 3900 2550 50  0001 C CNN
	1    3900 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 2550 3700 2550
Text GLabel 4100 2550 2    50   Input ~ 0
GND
$EndSCHEMATC
