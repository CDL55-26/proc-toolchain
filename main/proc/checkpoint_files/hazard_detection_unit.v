module hazard_detection_unit(
    output A_WB_XM_Hazard_mux_select,
    output A_WB_XM_BexSetx_select,
    output A_BexSetx_vs_other_Hazard_mux_select,
    output ALU_A_Bypass_mux_select,
    output B_WB_XM_Hazard_mux_select,
    output ALU_B_Bypass_mux_select,
    input [31:0] FD_Latch_Instr, DX_Latch_Instr, XM_Latch_Instr, WB_Latch_Instr
);


wire [4:0] FD_opcode_wire, FD_rd_wire, FD_rs_wire, FD_rt_wire, FD_shamt_wire, FD_ALU_op_wire;
wire [16:0] FD_immediate_wire;

wire [4:0] DX_opcode_wire, DX_rd_wire, DX_rs_wire, DX_rt_wire, DX_shamt_wire, DX_ALU_op_wire;
wire [16:0] DX_immediate_wire;
wire [31:0] DX_target;

wire [4:0] XM_opcode_wire, XM_rd_wire, XM_rs_wire, XM_rt_wire, XM_shamt_wire, XM_ALU_op_wire;
wire [16:0] XM_immediate_wire;
wire [31:0] XM_target;

wire [4:0] WB_opcode_wire, WB_rd_wire, WB_rs_wire, WB_rt_wire, WB_shamt_wire, WB_ALU_op_wire;
wire [16:0] WB_immediate_wire;
wire [31:0] WB_target;

wire ALU_A_XM_Arithmetic_Hazard, ALU_A_XM_Branch_Hazard, ALU_A_XM_JR_Hazard;
wire ALU_A_WB_Arithmetic_Hazard, ALU_A_WB_Branch_Hazard, ALU_A_WB_JR_Hazard;

wire ALU_B_XM_Arithmetic_Hazard, ALU_B_XM_Branch_Hazard;
wire ALU_B_WB_Arithmetic_Hazard, ALU_B_WB_Branch_Hazard;


/* FD Instruction */
            //parse instructions
            assign FD_opcode_wire = FD_Latch_Instr[31:27];
            assign FD_rd_wire = FD_Latch_Instr[26:22];
            assign FD_rs_wire = FD_Latch_Instr[21:17];
            assign FD_rt_wire = FD_Latch_Instr[16:12];
            assign FD_shamt_wire = FD_Latch_Instr[11:7];
            assign FD_ALU_op_wire = FD_Latch_Instr[6:2];

            //immediate for i-type
            assign FD_immediate_wire = FD_Latch_Instr[16:0];

        /* DX Instruction */
            //parse instructions
            assign DX_opcode_wire = DX_Latch_Instr[31:27];
            assign DX_rd_wire = DX_Latch_Instr[26:22];
            assign DX_rs_wire = DX_Latch_Instr[21:17];
            assign DX_rt_wire = DX_Latch_Instr[16:12];
            assign DX_shamt_wire = DX_Latch_Instr[11:7];
            assign DX_ALU_op_wire = DX_Latch_Instr[6:2];

            //immediate for i-type
            assign DX_immediate_wire = DX_Latch_Instr[16:0];

            //target for j type
            assign DX_target = {{5{DX_Latch_Instr[26]}}, DX_Latch_Instr[26:0]}; //sign extend target


        /* XM Instructions */
            //parse instructions
            assign XM_opcode_wire = XM_Latch_Instr[31:27];
            assign XM_rd_wire = XM_Latch_Instr[26:22];
            assign XM_rs_wire = XM_Latch_Instr[21:17];
            assign XM_rt_wire = XM_Latch_Instr[16:12];
            assign XM_shamt_wire = XM_Latch_Instr[11:7];
            assign XM_ALU_op_wire = XM_Latch_Instr[6:2];

            //immediate for i-type
            assign XM_immediate_wire = XM_Latch_Instr[16:0];

            //target for j type
            assign XM_target = {{5{XM_Latch_Instr[26]}}, XM_Latch_Instr[26:0]}; //sign extend target

        /* WB Instructions */
            //parse instructions
            assign WB_opcode_wire = WB_Latch_Instr[31:27];
            assign WB_rd_wire = WB_Latch_Instr[26:22];
            assign WB_rs_wire = WB_Latch_Instr[21:17];
            assign WB_rt_wire = WB_Latch_Instr[16:12];
            assign WB_shamt_wire = WB_Latch_Instr[11:7];
            assign WB_ALU_op_wire = WB_Latch_Instr[6:2];

            //immediate for i-type
            assign WB_immediate_wire = WB_Latch_Instr[16:0];

            //target for j type
            assign WB_target = {{5{WB_Latch_Instr[26]}}, WB_Latch_Instr[26:0]}; //sign extend target



/*Control For ALU input A*/

    //A_DX_XM_Hazard_mux
    assign ALU_A_XM_Arithmetic_Hazard = ((DX_opcode_wire==5'd0)||(DX_opcode_wire==5'd5)) && ((((XM_opcode_wire==5'd0)||(XM_opcode_wire==5'd5)) && (DX_rs_wire==XM_rd_wire)) || ((XM_opcode_wire==5'd3) && (DX_rs_wire==5'd31)));
    assign ALU_A_XM_Branch_Hazard = ((DX_opcode_wire==5'd2)||(DX_opcode_wire==5'd6)) && ((((XM_opcode_wire==5'd0)||(XM_opcode_wire==5'd5)) && (DX_rd_wire==XM_rd_wire)) || ((XM_opcode_wire==5'd3) && (DX_rd_wire==5'd31)));//for branch rd goes into Alu A
    assign ALU_A_XM_JR_Hazard = (DX_opcode_wire==5'd4) && ((((XM_opcode_wire==5'd0)||(XM_opcode_wire==5'd5)) && (DX_rd_wire==XM_rd_wire)) || ((XM_opcode_wire==5'd3) && (DX_rd_wire==5'd31)));//for jr rd is the A output  
    
    assign A_WB_XM_Hazard_mux_select = ALU_A_XM_Arithmetic_Hazard | ALU_A_XM_Branch_Hazard | ALU_A_XM_JR_Hazard; //1 if taking bypass from XM

    //A_WB_XM_BexSetx_mux
    assign A_WB_XM_BexSetx_select = (DX_opcode_wire=5'd22) && (XM_opcode_wire == 5'd21); //1 if setx followed by bex
    //A_BexSetx_vs_other_Hazard_mux
    assign A_BexSetx_vs_other_Hazard_mux_select = A_WB_XM_BexSetx_select || ((DX_opcode_wire=5'd22) && (WB_opcode_wire == 5'd21)); //bex in DX, setx in Write Back

    //ALU_A_Bypass_mux
    assign ALU_A_WB_Arithmetic_Hazard = ((DX_opcode_wire==5'd0)||(DX_opcode_wire==5'd5)) && ((((WB_opcode_wire==5'd0)||(WB_opcode_wire==5'd5)) && (DX_rs_wire==WB_rd_wire)) || ((WB_opcode_wire==5'd3) && (DX_rs_wire==5'd31)));
    assign ALU_A_WB_Branch_Hazard = ((DX_opcode_wire==5'd2)||(DX_opcode_wire==5'd6)) && ((((WB_opcode_wire==5'd0)||(WB_opcode_wire==5'd5)) && (DX_rd_wire==WB_rd_wire)) || ((WB_opcode_wire==5'd3) && (DX_rd_wire==5'd31)));//for branch rd goes into Alu A
    assign ALU_A_WB_JR_Hazard = (DX_opcode_wire==5'd4) && ((((WB_opcode_wire==5'd0)||(WB_opcode_wire==5'd5)) && (DX_rd_wire==WB_rd_wire)) || ((WB_opcode_wire==5'd3) && (DX_rd_wire==5'd31)));//for jr rd is the A output
  

    assign ALU_A_Bypass_mux_select = A_WB_XM_Hazard_mux_select | (ALU_A_WB_Arithmetic_Hazard|ALU_A_WB_Branch_Hazard|ALU_A_WB_JR_Hazard);

    //B_DX_XM_Hazard_mux
    assign ALU_B_XM_Arithmetic_Hazard = ((DX_opcode_wire==5'd0)||(DX_opcode_wire==5'd5)) && ((((XM_opcode_wire==5'd0)||(XM_opcode_wire==5'd5)) && (DX_rt_wire==XM_rd_wire)) || ((XM_opcode_wire==5'd3) && (DX_rt_wire==5'd31)));
    assign ALU_B_XM_Branch_Hazard = ((DX_opcode_wire==5'd2)||(DX_opcode_wire==5'd6)) && ((((XM_opcode_wire==5'd0)||(XM_opcode_wire==5'd5)) && (DX_rs_wire==XM_rd_wire)) || ((XM_opcode_wire==5'd3) && (DX_rs_wire==5'd31)));//for branch rd goes into Alu A
 
    assign B_WB_XM_Hazard_mux_select = ALU_B_XM_Arithmetic_Hazard | ALU_B_XM_Branch_Hazard;

    //ALU_B_Bypass_mux
    assign ALU_B_WB_Arithmetic_Hazard = ((DX_opcode_wire==5'd0)||(DX_opcode_wire==5'd5)) && ((((WB_opcode_wire==5'd0)||(WB_opcode_wire==5'd5)) && (DX_rt_wire==WB_rd_wire)) || ((WB_opcode_wire==5'd3) && (DX_rt_wire==5'd31)));
    assign ALU_B_WB_Branch_Hazard = ((DX_opcode_wire==5'd2)||(DX_opcode_wire==5'd6)) && ((((WB_opcode_wire==5'd0)||(WB_opcode_wire==5'd5)) && (DX_rs_wire==WB_rd_wire)) || ((WB_opcode_wire==5'd3) && (DX_rs_wire==5'd31)));//for branch rd goes into Alu A

    assign ALU_B_Bypass_mux_select = B_WB_XM_Hazard_mux_select | (ALU_B_WB_Arithmetic_Hazard|ALU_B_WB_Branch_Hazard);


endmodule
