module router_fsm_tb();


reg clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid;
           reg [1:0] data_in;
wire write_enb_reg,detect_add,lfd_state,laf_state,ld_state,full_state,rst_int_reg,busy;


parameter cycle = 20;

router_fsm DUT(clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,
             data_in,write_enb_reg,detect_add,lfd_state,laf_state,ld_state,full_state,rst_int_reg,busy);


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


task sr0();
begin
@(negedge clock);
soft_reset_0=1'b1;
@(negedge clock);
soft_reset_0=1'b0;
end
endtask


task sr1();
begin
@(negedge clock);
soft_reset_1=1'b1;
@(negedge clock);
soft_reset_1=1'b0;
end
endtask

task sr2();
begin
@(negedge clock);
soft_reset_2=1'b1;
@(negedge clock);
soft_reset_2=1'b0;
end
endtask


task t1;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b00;
fifo_empty_0=1'b1;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
pkt_valid=1'b0;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
end
endtask


task t2;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1=1'b1;
@(negedge clock);
@(negedge clock);
fifo_full=1'b1;
@(negedge clock);
fifo_full=1'b0;
@(negedge clock);
parity_done=1'b1;
@(negedge clock);
end
endtask



task t3;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b10;
fifo_empty_2=1'b1;
@(negedge clock);
@(negedge clock);
fifo_full=1'b1;
@(negedge clock);
fifo_full=1'b0;
@(negedge clock);
parity_done = 1'b0;
low_packet_valid = 1'b1;
@(negedge clock);
@(negedge clock);
fifo_full=1'b0;
@(negedge clock);
end
endtask

task t4;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b00;
fifo_empty_0=1'b1;
@(negedge clock);
@(negedge clock);
fifo_full=1'b1;
@(negedge clock);
fifo_full=1'b0;
@(negedge clock);
parity_done = 1'b0;
low_packet_valid = 1'b0;
@(negedge clock);
fifo_full=1'b0;
pkt_valid= 1'b0;
@(negedge clock);
@(negedge clock);
fifo_full = 1'b0;
@(negedge clock);
end
endtask

task t5;
begin
@(negedge clock);
pkt_valid = 1'b1;
data_in = 2'b00;
fifo_empty_0=1'b1;
@(negedge clock);
@(negedge clock);
fifo_full=1'b0;
pkt_valid=1'b0;
@(negedge clock);
@(negedge clock);
fifo_full=1'b1;
@(negedge clock);
fifo_full=1'b0;
@(negedge clock);
parity_done=1'b0;
@(negedge clock);
end
endtask



initial
begin
rst();
sr0();
sr1();
sr2();
t1();
t2();
t3();
t4();
t5();
end
endmodule









