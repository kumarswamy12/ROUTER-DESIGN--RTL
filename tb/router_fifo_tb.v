module router_fifo_tb();

reg clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
reg[7:0]data_in;
wire full,empty;
wire[7:0]data_out;
parameter cycle=100;

router_fifo DUT( clock,resetn,write_enb,read_enb,soft_reset,lfd_state,
		                     data_in,full,empty,data_out);
            
//clock generation
always
begin
#(cycle/2);
clock=1'b1;
#(cycle/2);
clock=~clock;
end

//reset 
 task rst();
begin
@(negedge clock);
resetn=1'b0;
@(negedge clock);
resetn=1'b1;
end
endtask



//softreset 
 task softrst();
begin
@(negedge clock);
soft_reset=1'b1;
@(negedge clock);
soft_reset=1'b0;
end
endtask


// read 
 
task read(input m);
 begin
read_enb=m;

end
endtask
 
//write

 task write(input s);
 begin
write_enb=s;
end
endtask



//packet generation
task packet_gen;
reg[7:0]payload_data,parity,header;
reg[5:0] payload_length;
reg[1:0]addr;
integer i;
begin
@(negedge clock);
payload_length =6'd4;
addr = 2'b01;
header = {payload_length,addr};
data_in =header;
write_enb = 1'b1;
lfd_state = 1'b1;
for(i=0; i<payload_length;i=i+1)
begin
@(negedge clock);
payload_data = {$random}%256;
data_in = payload_data;
lfd_state =1'b0;
end
@(negedge clock);
parity = {$random}%256;
data_in=parity;
end
endtask
initial
begin
rst();
softrst();
#100;
packet_gen;
@(negedge clock);
write(0);
read(1);
end
endmodule
