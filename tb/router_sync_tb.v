module router_sync_tb;

	// Inputs
	reg clock;
	reg resetn;
	reg detect_add;
	reg write_enb_reg;
	reg full_0;
	reg full_1;
	reg full_2;
	reg empty_0;
	reg empty_1;
	reg empty_2;
	reg read_enb_0;
	reg read_enb_1;
	reg read_enb_2;
	reg [1:0] data_in;

	// Outputs
	wire fifo_full;
	wire soft_reset_0;
	wire soft_reset_1;
	wire soft_reset_2;
	wire [2:0] write_enb;
	wire vld_out_0;
	wire vld_out_1;
	wire vld_out_2;

	// Instantiate the Unit Under Test (UUT)
	router_sync uut (
		.clock(clock), 
		.resetn(resetn), 
		.detect_add(detect_add), 
		.write_enb_reg(write_enb_reg), 
		.full_0(full_0), 
		.full_1(full_1), 
		.full_2(full_2), 
		.empty_0(empty_0), 
		.empty_1(empty_1), 
		.empty_2(empty_2), 
		.read_enb_0(read_enb_0), 
		.read_enb_1(read_enb_1), 
		.read_enb_2(read_enb_2), 
		.data_in(data_in), 
		.fifo_full(fifo_full), 
		.soft_reset_0(soft_reset_0), 
		.soft_reset_1(soft_reset_1), 
		.soft_reset_2(soft_reset_2), 
		.write_enb(write_enb), 
		.vld_out_0(vld_out_0), 
		.vld_out_1(vld_out_1), 
		.vld_out_2(vld_out_2)
	);
parameter cycle=20;
always
	begin
	#(cycle/2);
	clock=1'b0;
	#(cycle/2);
	clock=~clock;
	end
task rst_dut;
	begin
	@(negedge clock);
	resetn=1'b0;
	@(negedge clock);
	resetn=1'b1;
	end
endtask
task detect;
	begin
	@(negedge clock);
	detect_add=1'b1;
	@(negedge clock);
	detect_add=1'b0;
	end
endtask
task write(input b);
	begin
	@(negedge clock);
	write_enb_reg=b;
	end
endtask
task stimulus(input k,l,m);
	begin
	full_0=k;
	full_1=l;
	full_2=m;
	end
endtask
task stimulus1(input p,q,r);
	begin
	empty_0=p;
	empty_1=q;
	empty_2=r;
	end
endtask
task read(input s,t,u);
	begin
	read_enb_0=s;
	read_enb_1=t;
	read_enb_2=u;
	end
endtask
initial
	begin
	#10;
	rst_dut;
	detect;
	#10;
	data_in=2'b00;
	stimulus(0,0,0);
	stimulus1(0,0,0);
	read(0,1,1);
write(1);
	#10;
	data_in=2'b10;
	stimulus(0,0,0);
	stimulus1(0,0,0);
	read(1,1,0);
	end      
endmodule

