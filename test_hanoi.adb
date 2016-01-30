with Robot_Monitor;   use Robot_Monitor;
with Robot_Interface; use Robot_Interface;
with Digital_IO_Sim;  use Digital_IO_Sim;
with Ada.Text_IO; use Ada;

with Ada.Integer_Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

procedure Test_Hanoi is
   Target_Pos : array (1 .. 4) of Position :=
     (1 => (100, 100, 100, 10),
      2 => (5, 50, 200, 20),
      3 => (300, 300, 300, 30),
      4 => (111,222,333,0));

 
    type Piquete is ('A', 'B', 'C');
    package Peg_IO is new Ada.Text_IO.Enumeration_IO (Piquete);
    type Disks is ('1','2','3');
    package Disk_IO is new Ada.Text_IO.Enumeration_IO (Disks);
    
    type Piezas is Array (Piquete'Range) of Natural;
    Max_Piezas : Natural := 3;
    Mis_Piezas : Piezas;
    au : Natural;
    Actual_Position : Position;
    Initial_Position : Position;
 
 
    procedure MoveDisk (D: Disks; From, To: Piquete) is
    
    begin
    
    -- mover la rotación al origen
    Text_IO.Put_Line ("Moviendo al origen");  
    Actual_Position := Robot_Mon.Get_Pos;
    if From = 'A' then au:=100;
    elsif From = 'B' then au:=200;
    elsif From = 'C' then au:=300;
    end if;
    Actual_Position(Rotation):=au;
    Move_Robot_To(Actual_Position);
    ------------------------------------
    delay 6.0;
    -- abrir pinza
    Text_IO.Put_Line ("Abrir Pinza");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Clamp):=0;
    Move_Robot_To(Actual_Position);
    delay 6.0;
    
    -- mover altura hacia la del origen para cojer
    Text_IO.Put_Line ("Moviendo altura para bajar hacía a la pieza en origen");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Height):=300-(Mis_Piezas(From)*50)+20;
    Move_Robot_To(Actual_Position);
    delay 6.0;
    -- cerrar la pinza
    Text_IO.Put_Line ("Cerrar la pinza");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Clamp):=20;
    Move_Robot_To(Actual_Position);
    delay 6.0;
    -- mover altura (generico)
    Text_IO.Put_Line ("Moviendo eje de altura hacia arriba llevando el objeto");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Height):=300-((Max_Piezas+1)*50)-20;
    Move_Robot_To(Actual_Position);
    delay 6.0;
    -- decrementar el valor de piezas del origen  
    Mis_piezas(From):= Mis_piezas(From) - 1;
    delay 6.0;
    -- mover rotación al destino
    Text_IO.Put_Line ("Moviendo rotación al destino");  
    Actual_Position := Robot_Mon.Get_Pos;
    if To = 'A' then au:=100;
    elsif To = 'B' then au:=200;
    elsif To = 'C' then au:=300;
    end if;
    Actual_Position(Rotation):=au;
    Move_Robot_To(Actual_Position);
    delay 6.0;
    -- mover altura destino (comprobar altura)
    Text_IO.Put_Line ("Moviendo altura para bajar al destino");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Height):=300-((Mis_Piezas(To)+1)*50)+20;
    Move_Robot_To(Actual_Position);    
    delay 6.0;
    -- abrir la pinza
    Text_IO.Put_Line ("Abriendo la pinza para soltar");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Clamp):=0;
    Move_Robot_To(Actual_Position);
    delay 6.0;
    -- subir la altura para alejarse de las piezas
    Text_IO.Put_Line ("Moviendo eje de altura hacia arriba para alejarse de las piezas");  
    Actual_Position := Robot_Mon.Get_Pos;
    Actual_Position(Height):=300-((Max_Piezas+1)*50)-20;
    Move_Robot_To(Actual_Position);
    delay 6.0;    
    -- incrementar el valor de pieza del destino
    Mis_piezas(To):= Mis_piezas(To)+1;
    Text_IO.Put_Line ("Incrementando contador de piezas");  
    
    
    
    
       Disk_IO.Put (D, Width=>10);
       Text_IO.Put (" disk from tower ");  Peg_IO.Put (From);
       Text_IO.Put (" to tower ");         Peg_IO.Put (To);
       Text_IO.New_Line;
    end MoveDisk;
 

    procedure Tower (From, To, Aux: Piquete; N: Disks) is
    begin
       if N=Disks'First then
          MoveDisk (Disks'First, From, To);
       else
          Tower (From, Aux, To, Disks'Pred(N));
          MoveDisk (N, From, To);
          Tower (Aux, To, From, Disks'Pred(N));
       end if;
    end Tower;
 
begin

    Mis_Piezas('A'):=3;
    Mis_Piezas('B'):=0;
    Mis_Piezas('C'):=0;
    Initial_Position := (Rotation => 0,
                         Forward => 0,
                         Height => 0,
                         Clamp => 0);
    
   
   
   Put_Line("Test_Hanoi starts...");
   Robot_Mon.Reset;
   delay 3.0;

    Tower (From=>'A', To=>'B', Aux=>'C', N=>Disks'Last);


 
 end Test_Hanoi;
