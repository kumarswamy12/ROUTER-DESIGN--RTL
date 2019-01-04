module router_reg_tb();
parameter cycle = 20;
	// Inputs
	reg clock;
	reg resetn;
	reg pkt_valid;
	reg fifo_full;
	reg detect_add;
	reg ld_state;
	reg laf_state;
	reg full_state;
	reg lfd_state;
	reg rst_int_reg;
	reg [7:0] data_in;

	// Outputs
	wire err;
	wire parity_done;
	wire low_packet_valid;
	wire [7:0] dout;

	// Instantiate the Unit Under Test (UUT)
	router_reg uut (
		.clock(clock), 
		.resetn(resetn), 
		.pkt_valid(pkt_valid), 
		.fifo_full(fifo_full), 
		.detect_add(detect_add), 
		.ld_state(ld_state), 
		.laf_state(laf_state), 
		.full_state(full_state), 
		.lfd_state(lfd_state), 
		.rst_int_reg(rst_int_reg), 
		.data_in(data_in), 
		.err(err), 
		.parity_done(parity_done), 
		.low_packet_valid(low_packet_valid), 
		.dout(dout)
	);

	initial 
	  begin
		// Initialize Inputs
		clock = 0;
		resetn = 0;
		pkt_valid = 0;
		fifo_full = 0;
		detect_add = 0;
		ld_state = 0;
		laf_state = 0;
		full_state = 0;
		lfd_state = 0;
		rst_int_reg = 0;
		data_in = 0;
		
		end
		//clock generation
		always
		begin
		#(cycle/2);
		clock=1'b0;
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



 // packet generation
   task gpacket_gen();
	
	reg [7:0] payload_data,parity,header;
	reg [5:0] payload_length;
	reg [1:0] addr;
	integer i;
	begin
	@(negedge clock);
	payload_length=6'd3;
	addr=2'b01;
	pkt_valid=1;
	detect_add=1;
	header = {payload_length,addr};
	parity = 0^header;
	data_in= header;
	@(negedge clock);
	detect_add=0;
	full_state=0;
fifo_full=0;
lfd_state = 1;
laf_state = 0;
for(i=0;i<payload_length;i=i+1)
begin
@(negedge clock);
lfd_state = 0;
ld_state = 1;
payload_data = {$random}%256;
data_in = payload_data;
parity= parity^data_in;
end
@(negedge clock);
pkt_valid = 0;
data_in =parity;
@(negedge clock);
ld_state = 0;

end
endtask




 // packet generation
   task bpacket_gen();
	
	reg [7:0] payload_data,parity,header;
	reg [5:0] payload_length;
	reg [1:0] addr;
	integer i;
	begin
	@(negedge clock);
	payload_length=6'd3;
	addr=2'b01;
	pkt_valid=1;
	detect_add=1;
	header = {payload_length,addr};
	parity = 0^header;
	data_in= header;
	@(negedge clock);
	detect_add=0;
	full_state=0;
fifo_full=0;
lfd_state = 1;
laf_state = 0;
for(i=0;i<payload_length;i=i+1)
begin
@(negedge clock);
lfd_state = 0;
ld_state = 1;
payload_data = {$random}%256;
data_in = payload_data;
parity= parity^data_in;
end
@(negedge clock);
pkt_valid = 0;
data_in = ~parity;
@(negedge clock);
ld_state = 0;
end
endtask




initial
begin
rst();
gpacket_gen();	
bpacket_gen();	

		

end
      
 endmodule

