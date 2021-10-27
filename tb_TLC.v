`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2018 23:43:56
// Design Name: 
// Module Name: tb_TLC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_TLC();
`define EOF -1
reg clk, btn;
wire [2:0] n_lights,s_lights,e_lights,w_lights;
wire [6:0] segment;
wire an;
reg [15:0] input_ligth_status;
wire [15:0] output_ligth_status;
reg [15:0] mem [15:0];
integer i,j;
// The file handle for the input file
integer file_id;
// The character received from $fgetc
integer c,of;
// The status register from $sscanf
integer r;
integer cl;
// Line buffer
reg [8*100:1] line;

// Command
reg [8*25:1]  cmd;

// The arguments extracted from the line
reg [7:0] a0;
reg [15:0] a1;
reg [7:0] a2;
reg [15:0] a3;
reg [7:0] char;
reg [19:0] trans [0:17] [0:1];
reg [19:0] input_ligth_status_;
reg [3:0] a2_;
reg [8*256:1] filePath,filePathr; // Dosyanýn yazýlacaðý yer
reg [8*3:1] x; // m44 gibi deðiþkenlerini vardý gördüðüm kadarýyla, burada 8*3 sayýsýndaki 3 "m44" ismi için karakter sayýsý, dosya results_m44.txt olarak kaydediliyor.

initial begin

  x="m09";
  
  $sformat(filePathr,"C:\\Users\\Onur\\Desktop\\HW_Experiment 2.0\\Test Generation\\PQTestGen\\%s\\Forward Right Decoded (FPGA) Test Cases.txt",x);
  file_id = $fopen(filePathr,"r");
  //file_id = $fopen("C:\\Users\\Onur\\Desktop\\HW_Experiment 2.0\\Test Execution\\ReTestGen\\Decoded (FPGA) Test Cases_%s.txt", "r",x);
//$readmemh("D:\\MYPROJECTS\\FPGA\\Projects\\Traffic_Light_Four_Input\\test.txt",mem);
  // Check if the file has been opened  
  $sformat(filePath,"C:\\Users\\Onur\\Desktop\\HW_Experiment 2.0\\Test Execution\\Negative Testing\\PQTestGenResults\\results_%s.txt",x);
  of = $fopen(filePath,"w");
  if (of == 0) begin
    $display ("ERROR: test.txt not opened");
    $finish;
  end
  if (file_id == 0) begin
    $display ("ERROR: test.txt not opened");
    $finish;
  end
         
  input_ligth_status = 16'h0000;

  cl = 0;
  btn = 1;

  c = $fgetc(file_id);

  // Repeat while the given line is not the eof
  while (c != `EOF) begin
  
  line = "";
  cmd  = "";
  a0   = 8'b0;
  a1   = 16'b0;
  a2   = 8'b0;
  a3   = 16'b0;
  char   = 8'b0;
//  btn=1;
//  cl=!cl;
//  clk = cl;
  // Replace the character "c"
  r = $ungetc(c, file_id);
  // Get the next line
  r = $fgets(line, file_id);
  
   r = $sscanf(line, "%s %x", cmd, a0);
   
    if (r != 2) begin
      $display ("ERROR: Current line [%-s] not formatted correctly", line);
      $finish;
    end
    
    case (cmd)
          "CNT" : begin
            $display ("CNT value [%02x]", a0);
          end
        endcase
   

   for(i=0;i<a0;i=i+1)
    begin
       // Get the next line
       r = $fgets(line, file_id);
       r = $sscanf(line, "%h %h %c %h", a1,a2,char,a3);
       
       $display("*[%h],[%h],[%h]",a1,a2,a3);
              
       input_ligth_status = a1;
       btn=a2;
       cl=!cl;
       clk = cl;
   //btn = 0;
       #10
       $display("Output:[%h]",output_ligth_status);
       if (output_ligth_status != a3 )
                  begin
                  $display ("ERROR: Test Failed led status: %h not equal %h", output_ligth_status, a3);
                  $fwrite(of,"ERROR: Test Failed led status: %h not equal %h\nExecution time:%d ns\n", output_ligth_status, a3,$time);
                  $fclose(of);
                  $finish;
       end
       
       
   end
    // Get the first character on the next line
    
  c = $fgetc(file_id);  
         
  end // while
  $display ("INFORMATION: Test is finished");
  $fwrite(of,"INFORMATION: Test is finished\n Execution time:%d ns\n",$time);
  $fclose(of);
  $finish;
end
  


//always begin
//#5 clk = ! clk;
//end

TrafficLight TrafficLight_inst (
.n_lights (n_lights),
.s_lights (s_lights),
.e_lights (e_lights),
.w_lights (w_lights), 
.clk      (clk), 
.btn      (btn) , 
.segment  (segment),
.an       (an),
.input_ligth_status(input_ligth_status),
.output_ligth_status(output_ligth_status)
);

endmodule
