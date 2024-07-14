
$regfile = "m8def.dat"

$crystal = 16000000

Config Lcd = 20 * 4
Config Lcdpin = Pin , Db4 = Portd.5 , Db5 = Portd.6 , Db6 = Portd.7 , Db7 = Portd.4 , E = Portd.3 , Rs = Portd.2

Cursor Off

Config Adc = Single , Prescaler = Auto , Reference = Internal

Config Portc.3 = Input : Config Portc.4 = Output : Config Portc.5 = Output

Portc.3 = 1 : Portc.4 = 0 : Portc.5 = 0
Dim Kww As Single
Dim Kw As Single
Dim K As Integer
Dim Vp As Integer
Dim I As Integer
Dim Vo As Integer
Dim Vm As Integer
Dim J As Integer
Dim L As Integer
Dim Swr As Single
Dim Voo As Single
Dim Vpp As Single
Dim Vmm As Single
Dim Pm As Single
Dim Pmm As Single
Dim Pp As Single
Dim Ppp As Single
Dim Sm As Single
Dim M As Single
Cursor Off
Cls
Locate 2 , 1 : Lcd " PW - SWR - meter"
Locate 3 , 1 : Lcd " home made SQ7JHM"
Wait 2
Cls

Deflcdchar 0 , 32 , 32 , 32 , 32 , 32 , 32 , 32 , 31        ' puste pole znakowe
Deflcdchar 1 , 32 , 31 , 31 , 31 , 31 , 31 , 31 , 31        ' pole znakowe
Deflcdchar 2 , 32 , 31 , 17 , 17 , 27 , 10 , 27 , 32        ' omega
Deflcdchar 3 , 32 , 4 , 12 , 4 , 4 , 4 , 32 , 32            ' jedynka
Deflcdchar 4 , 32 , 14 , 2 , 14 , 8 , 14 , 32 , 32          ' dwójka
Deflcdchar 5 , 32 , 14 , 2 , 14 , 2 , 14 , 32 , 32          ' trójka
Deflcdchar 6 , 32 , 10 , 10 , 14 , 2 , 2 , 32 , 32          ' czwórka
Deflcdchar 7 , 32 , 14 , 8 , 14 , 2 , 14 , 32 , 32          ' pi¹tka

Start Adc

M = 0

Do
'--------------------------- Modu³ pomiaru mocy -------------------------------
If Pinc.3 = 0 Then
  Cls
  Portc.5 = 1                                               'w³¹czenie opornika pomiarowego 50ohm, przekaŸnik
  Ppp = 0
 For J = 1 To 15
  Locate 1 , 1 : Lcd " Pomiar Mocy "

  Vm = Getadc(1)                                            'pomiar napiêcia na oporniku 50 ohm
  Vmm = Vm * Vm
  Pm = Vmm / 3300000                                        'dobór wspó³czynników
  Pmm = 0.07 + Pm
  Pp = Vm * Pmm

  If Pp > Ppp Then
   Ppp = Pp
  End If

  Locate 3 , 1 : Lcd " Moc =" ; Fusing(ppp , "##.#") ; "W"


  For I = 1 To 20
   Locate 4 , I : Lcd Chr(0)
  Next For

  Waitms 600
 Next
  Cls
  Portc.5 = 0
End If
'-------------------------- Modu³ pomiaru SWR ---------------------------------
  Vp = Getadc(1)                                            'czyta padaj¹ca
  Vo = Getadc(2)                                            'czyta odbita
  L = Vp + Vo
  M = Vp - Vo
  Swr = L / M                                               'oblicza SWR
If Swr < 1 Then
 Swr = 1
 Locate 1 , 1 : Lcd " Pomiar SWR         "
 Else
 Locate 1 , 1 : Lcd " Pomiar SWR =" ; Fusing(swr , "#.#") ; "   "
End If

 Locate 4 , 3 : Lcd Chr(3)
 Locate 4 , 6 : Lcd Chr(4)
 Locate 4 , 9 : Lcd Chr(5)
 Locate 4 , 12 : Lcd Chr(6)
 Locate 4 , 15 : Lcd Chr(7)
 Swr = Swr * 3
 I = Round(swr)                                             'dane do linijki
 If I > 20 Then I = 20                                      'warunki brzegowe

 '-------------------------- Linijka Œwietlna ---------------------------------

 For K = 1 To I                                             'pola znakowe
   Locate 3 , K : Lcd Chr(1)
  Next
  I = I + 1
  For L = I To 20
   Locate 3 , L : Lcd Chr(0)                                'puste pola znakowe
  Next

Loop