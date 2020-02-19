`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/12 21:10:52
// Design Name: 
// Module Name: Keyboard
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


module Keyboard(
    input clk,  //ʱ���ź�
    input rst,  //��λ�ź�
    input ps2_clk,  //PS2ʱ���ź�
    input ps2_data, //PS2�����ź�
    output reg	[3:0] LED,   //����������ź�
    output reg enter    //�س��������ź�
    );
    reg ps2_clk_r1,ps2_clk_r2;
    wire ps2_clk_neg;
    reg [3:0] ps2_clk_cnt;
    reg [15:0] key;
    
    always@(posedge clk or posedge rst) 
    begin
        if(rst) 
            ps2_clk_r1	<= 1'b1; 
        else 
            ps2_clk_r1	<= ps2_clk;
    end
    
    always@(posedge clk or posedge rst) 
    begin
        if(rst) 
            ps2_clk_r2	<= 1'b1;
        else 
            ps2_clk_r2	<= ps2_clk_r1;
    end
    
    assign ps2_clk_neg = (ps2_clk_r1==1'b0)&&(ps2_clk_r2==1'b1);
    
    always@(posedge clk or posedge rst) 
    begin
        if(rst) 
            ps2_clk_cnt <= 4'd0;
        else if(ps2_clk_neg) begin
            if(ps2_clk_cnt>=4'd10) 
                ps2_clk_cnt <= 4'd0;
            else 
                ps2_clk_cnt <= ps2_clk_cnt + 4'd1;
        end
    end
    
    always@(posedge clk or posedge rst) 
    begin
        if(rst)
            key <= 16'hFFFF;
        else if(ps2_clk_neg) //��PS2ʱ���ź�ȷ�Ϲ���״̬
        begin
            //��������Ӧ��8������λ�������Ĵ���key��
            if((ps2_clk_cnt>=1)&&(ps2_clk_cnt<=8)) 
                key <= {ps2_data,key[15:1]};   
            else //����key���ֲ���
                key <= key;
        end
    end
    
    always @(*)
    begin
        if(key[15:0] == 16'b0111010111110000)
        begin
            LED <= 4'b0001;
            enter <= 1'b0;
        end
        else if(key[15:0] == 16'b0111001011110000)
        begin
            LED <= 4'b0010;
            enter <= 1'b0;
        end
        else if(key[15:0] == 16'b0111010011110000)
        begin
            LED <= 4'b0100;
            enter <= 1'b0;
        end
        else if(key[15:0] == 16'b0110101111110000)
        begin
            LED <= 4'b1000;
            enter <= 1'b0;
        end
        else if(key[15:0] == 16'b0101101011110000)
        begin
            LED <= 4'b0000;
            enter <= 1'b1;
        end
        else
        begin
            LED <= 0000;
            enter <= 0;
        end
    end

endmodule
