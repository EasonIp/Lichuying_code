module vga_driver4_move(clk, rst_n, en, hsync, vsync);

	input clk, rst_n;
	
	output [7:0] en;
	output reg hsync, vsync;
	
	reg [31:0] hcnt, vcnt;
	reg hflag, vflag;

/////	800*600*60 40.0MHz = 1056(128+88+800+40) * 628(4+23+600+1) * 60Hz
	parameter ha = 128;
	parameter hb = 88;
	parameter hc = 800;
	parameter hd = 40;
	parameter he = 1056;
	parameter va = 4;
	parameter vb = 23;
	parameter vc = 600;
	parameter vd = 1;
	parameter ve = 628;

/////	1280*1024*60 108.0MHz = 1688(112+248+1280+48) * 1066(3+38+1024+1) * 60Hz
//	parameter ha = 112;
//	parameter hb = 248;
//	parameter hc = 1280;
//	parameter hd = 48;
//	parameter he = 1688;
//	parameter va = 3;
//	parameter vb = 38;
//	parameter vc = 1024;
//	parameter vd = 1;
//	parameter ve = 1066;
	
	localparam hab = ha + hb;
	localparam hac = ha + hb + hc;
	localparam vab = va + vb;
	localparam vac = va + vb + vc;

	wire [19:0] addr;
	wire [7:0] q;

//	rom rom(.address(addr), .clock(clk), .q(q));
	tt_rom tt_rom(.address(addr), .clock(clk), .q(q));

	wire [9:0] i;
	wire [9:0] j;
	
	assign i = (hcnt-delta_h+2-hab)%200;
	assign j = (vcnt-delta_v-vab)%150;

//	assign i = ((hcnt+2-hab)>>2)%32;
//	assign j = ((vcnt-vab)>>3)%16;

//	assign addr = ((j<<5) + i)>>3;		// addr = (j*32+i)/8
	assign addr = j * 200 + i;		// addr = j * 200 + i

//	assign en = (hflag && vflag) ? 8'h55AA : 8'd0;
//	assign en = (hflag && vflag) ? {8{q[(((hcnt-hab)>>2)%32)%8]}} : 8'd0;
//	assign en = (hflag && vflag) ? {8{q[(hcnt-hab)%8]}} : 8'd0;
	assign en = (hflag && vflag && tt_hflag && tt_vflag) ? q : 8'd0;

	wire tt_hflag, tt_vflag;
	assign tt_hflag = ((hcnt >= hab+delta_h) && (hcnt < hab+delta_h+200)) ? 1 : 0;
	assign tt_vflag = ((vcnt >= vab+delta_v) && (vcnt < vab+delta_v+150)) ? 1 : 0;
	
//	wire [7:0] hblock;
//	wire [2:0] vblock;
	
//	assign hblock = (hcnt-hab)*8/25;
//	assign hblock = (hcnt-hab)/5;
//	assign vblock = (vcnt-vab)/75;
//	assign en = hflag && vflag ? {vblock,hblock} : 0;
//	assign en = hflag && vflag ? hblock : 0;

	reg [10:0] delta_h, delta_v;
	reg dir_h, dir_v;
	reg [19:0] move_count;
	
	parameter T10ms = 400_000; 	// 10ms / 25ns = 400_000, for 40MHz VGA clock
	
	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					move_count <= 0;
					dir_h = 1;
					dir_v = 1;
					delta_h <= 200;
					delta_v <= 200;
				end
			else
				begin
					if (move_count < T10ms - 1) 
						begin
							move_count <= move_count + 1;
							dir_h <= delta_h ? ((delta_h+200 >= hc) ? 0 : dir_h) : 1;
							dir_v <= delta_v ? ((delta_v+150 >= vc) ? 0 : dir_v) : 1;
						end
					else	
						begin
							move_count <= 0;
							dir_h <= delta_h ? ((delta_h+200 >= hc) ? 0 : dir_h) : 1;
							dir_v <= delta_v ? ((delta_v+150 >= vc) ? 0 : dir_v) : 1;
							delta_h <= dir_h ? (delta_h+1) : (delta_h ? delta_h-1 : 0);
							delta_v <= dir_v ? (delta_v+1) : (delta_v ? delta_v-1 : 0);
						end
				end
		end
	

	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					hcnt <= 0;
					vcnt <= 0;
				end
			else
				begin
					if (hcnt < he - 1) 
						hcnt <= hcnt + 1;
					else	
						begin
							hcnt <= 0;
							if (vcnt < ve -1) 
								vcnt <= vcnt + 1;
							else
								vcnt <= 0;
						end
				end
		end

	always @ (*)
		begin
			if (!rst_n)
				begin
					hsync = 1;
					hflag = 0;
//					tt_hflag = 0;
//					dir_h = 1;
				end
			else
				begin
					if (hcnt < ha)
						begin
							hsync = 0;	
							hflag = 0;
						end
					else if (hcnt < hab)
						begin
							hsync = 1;	
							hflag = 0;
						end
					else if (hcnt < hac)
						begin
							hsync = 1;	
							hflag = 1;
//							tt_hflag = ((hcnt >= hab+delta_h) && (hcnt < hab+delta_h+200)) ? 1 : 0;
//							dir_h = delta_h ? ((delta_h+200 >= hc) ? 0 : dir_h) : 1;
						end
					else if (hcnt < he)
						begin
							hsync = 1;	
							hflag = 0;
						end
				end
	end

	always @ (*)
		begin
			if (!rst_n)
				begin
					vsync = 1;
					vflag = 0;
//					tt_vflag = 0;
//					dir_v = 1;
				end
			else
				begin
					if (vcnt < va)
						begin
							vsync = 0;	
							vflag = 0;
						end
					else if (vcnt < vab)
						begin
							vsync = 1;	
							vflag = 0;
						end
					else if (vcnt < vac)
						begin
							vsync = 1;	
							vflag = 1;
//							tt_vflag = ((vcnt >= vab+delta_v) && (vcnt < vab+delta_v+150)) ? 1 : 0;
//							dir_v = delta_v ? ((delta_v+150 >= vc) ? 0 : dir_v) : 1;
						end
					else if (vcnt < ve)
						begin
							vsync = 1;	
							vflag = 0;
						end
				end
	end

//	always @ (posedge clk or negedge rst_n)
//	begin
//		if (!rst_n)
//			begin
//				hsync <= 1;
//				hflag <= 0;
//			end
//		else
//			begin
//				if (hcnt < ha)
//					begin
//						hsync <=	0;	
//						hflag <= 0;
//					end
//				else if (hcnt < hab)
//					begin
//						hsync <=	1;	
//						hflag <= 0;
//					end
//				else if (hcnt < hac)
//					begin
//						hsync <=	1;	
//						hflag <= 1;
//					end
//				else if (hcnt < he)
//					begin
//						hsync <=	1;	
//						hflag <= 0;
//					end
//			end
//	end
//
//	always @ (posedge clk or negedge rst_n)
//	begin
//		if (!rst_n)
//			begin
//				vsync <= 1;
//				vflag <= 0;
//			end
//		else
//			begin
//				if (vcnt < va)
//					begin
//						vsync <=	0;	
//						vflag <= 0;
//					end
//				else if (vcnt < vab)
//					begin
//						vsync <=	1;	
//						vflag <= 0;
//					end
//				else if (vcnt < vac)
//					begin
//						vsync <=	1;	
//						vflag <= 1;
//					end
//				else if (vcnt < ve)
//					begin
//						vsync <=	1;	
//						vflag <= 0;
//					end
//			end
//	end

endmodule
