module arm(
    input clk, rst, en_forwarding);

    wire MEM_ready;            
    wire branch_taken_EXE_out, branch_taken_ID_out;
    wire hazard_detected, flush;
    wire[31:0] branch_address;
    wire[31:0] PC_IF, PC_ID;
                                
    wire[31:0] Instruction_IF;
    
    assign flush = branch_taken_ID_out;


    IF_stage_module if_stage_module(
        .clk(clk),
        .rst(rst),
        .freeze_in(hazard_detected | ~MEM_ready),
        .branch_taken_in(branch_taken_ID_out),
        .flush_in(flush),
        .branchAddr_in(branch_address),
        .pc_out(PC_IF),
        .instruction_out(Instruction_IF)
    );

    wire ID_two_src, ignore_hazard_ID_out;
    wire [3:0] reg_file_second_src_out, reg_file_first_src_out;
    wire [3:0] status_reg_ID_out;
    
    wire mem_read_ID_out, mem_write_ID_out,
        wb_enable_ID_out, immediate_ID_out,
        status_write_enable_ID_out;
        
    wire [3: 0] execute_command_ID_out;
    wire [31:0] reg_file_ID_out1, reg_file_ID_out2;
    wire [3:0] staged_reg_file_ID_out1, staged_reg_file_ID_out2;
    wire [3:0] dest_reg_ID_out;
    wire [23:0] signed_immediate_ID_out;
    wire [11:0] shift_operand_ID_out;
    
    wire wb_enable_WB_out;  
    wire [3:0] wb_dest_WB_out;
    wire [31:0] wb_value_WB;
    wire[3:0] status_reg_ID_in;

    ID_stage_module id_stage_module(
        // inputs
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .freeze(~MEM_ready),
        .pc_in(PC_IF),
        .instruction_in(Instruction_IF),
        .status_reg_in(status_reg_ID_in),
        .reg_file_wb_data(wb_value_WB),
        .reg_file_wb_address(wb_dest_WB_out),
        .reg_file_wb_en(wb_enable_WB_out),
        .hazard(hazard_detected),
        // outputs
        .two_src_out(ID_two_src),
        .ignore_hazard_out(ignore_hazard_ID_out),
        .reg_file_second_src_out(reg_file_second_src_out),
        .reg_file_first_src_out(reg_file_first_src_out),
        .pc_out(PC_ID),
        .mem_read_en_out(mem_read_ID_out),
        .mem_write_en_out(mem_write_ID_out),
        .wb_enable_out(wb_enable_ID_out),
        .immediate_out(immediate_ID_out),
        .branch_taken_out(branch_taken_ID_out),
        .status_write_enable_out(status_write_enable_ID_out),
        .execute_command_out(execute_command_ID_out),
        .reg_file_out1(reg_file_ID_out1),
        .reg_file_out2(reg_file_ID_out2),
        .dest_reg_out(dest_reg_ID_out),
        .signed_immediate_out(signed_immediate_ID_out),
        .shift_operand_out(shift_operand_ID_out),
        .status_reg_out(status_reg_ID_out),
        .staged_reg_file_second_src_out(staged_reg_file_ID_out1),
        .staged_reg_file_first_src_out(staged_reg_file_ID_out2)
    );

    wire [1:0] EXE_alu_mux_sel_src1, EXE_alu_mux_sel_src2;
    wire wb_enable_EXE_out, mem_read_EXE_out, mem_write_EXE_out;
    wire [31:0] alu_res_EXE_out, val_Rm_EXE_out;
    wire [3:0] dest_EXE_out;

    wire wb_en_hazard_EXE_out;
    wire [3:0] dest_hazard_EXE_out;
    wire status_w_en_EXE_out;
    wire [3:0] status_reg_EXE_out;

    EXE_stage_module exe_stage_module(
        // inputs
        .clk(clk),
        .rst(rst),
        .freeza(~MEM_ready),
        .pc_in(PC_ID),
        .wb_en_in(wb_enable_ID_out),
        .mem_r_en_in(mem_read_ID_out),
        .mem_w_en_in(mem_write_ID_out),
        .status_w_en_in(status_write_enable_ID_out),
        .branch_taken_in(branch_taken_ID_out),
        .immd(immediate_ID_out),
        .exe_cmd(execute_command_ID_out),
        .val_Rn(reg_file_ID_out1),
        .val_Rm_in(reg_file_ID_out2),
        .dest_in(dest_reg_ID_out),
        .signed_immd_24(signed_immediate_ID_out),
        .shift_operand(shift_operand_ID_out),
        .status_reg_in(status_reg_ID_out),
        .alu_mux_sel_src1(EXE_alu_mux_sel_src1),
        .alu_mux_sel_src2(EXE_alu_mux_sel_src2),
        .MEM_wb_value(alu_res_EXE_out),
        .WB_wb_value(wb_value_WB),
         // outputs
        .wb_en_out(wb_enable_EXE_out),
        .mem_r_en_out(mem_read_EXE_out),
        .mem_w_en_out(mem_write_EXE_out),
        .alu_res_out(alu_res_EXE_out),
        .val_Rm_out(val_Rm_EXE_out),
        .dest_out(dest_EXE_out),
        .wb_en_hazard_in(wb_en_hazard_EXE_out),
        .dest_hazard_in(dest_hazard_EXE_out),
        .status_w_en_out(status_w_en_EXE_out),
        .branch_taken_out(branch_taken_EXE_out),
        .statusRegister_out(status_reg_EXE_out),
        .branch_address_out(branch_address)
    );


    wire wb_en_MEM_out, mem_r_en_MEM_out;
    wire [31:0] alu_res_MEM_out, mem_res_MEM_out;
    wire [3:0] dest_MEM_out;

    wire wb_en_hazard_MEM_out;
    wire [3:0] dest_hazard_MEM_out;
    
    MEM_stage_module mem_stage_module(
            .clk(clk), .rst(rst),
            .freeze(~MEM_ready),
            .wb_en_in(wb_enable_EXE_out),
            .mem_r_en_in(mem_read_EXE_out),
            .mem_w_en_in(mem_write_EXE_out),
            .alu_res_in(alu_res_EXE_out), .val_Rm(val_Rm_EXE_out),
            .dest_in(dest_EXE_out),

            .wb_en_out(wb_en_MEM_out), .mem_r_en_out(mem_r_en_MEM_out),
            .alu_res_out(alu_res_MEM_out), .mem_res_out(mem_res_MEM_out),
            .dest_out(dest_MEM_out),

            .wb_en_hazard_in(wb_en_hazard_MEM_out),
            .dest_hazard_in(dest_hazard_MEM_out),
            .ready(MEM_ready)
    );

        WB_stage wb_stage(
            .clk(clk),
            .rst(rst),
            .mem_read_enable(mem_r_en_MEM_out),
            .wb_enable_in(wb_en_MEM_out),
            
            .alu_result(alu_res_MEM_out),
            .data_memory(mem_res_MEM_out),
            .wb_dest_in(dest_MEM_out),
        
            .wb_enable_out(wb_enable_WB_out),
            .wb_dest_out(wb_dest_WB_out),
            .wb_value(wb_value_WB)
    );



    hazard_detection_unit hazard_detection_unit(
        .with_forwarding(en_forwarding),
        .have_two_src(ID_two_src),
        .src1_address(reg_file_first_src_out),
        .src2_address(reg_file_second_src_out),
        .ignore_hazard(ignore_hazard_ID_out),
        .ignore_from_forwarding(ignore_hazard_forwarding_out),
            
        .EXE_mem_read_en(mem_read_ID_out),
        .exe_wb_dest(dest_hazard_EXE_out),
        .exe_wb_en(wb_en_hazard_EXE_out),
        .mem_wb_dest(dest_hazard_MEM_out),
        .mem_wb_en(wb_en_hazard_MEM_out),
        .hazard_detected(hazard_detected)
    );

    Forwarding forwarding(
        .en_forwarding(en_forwarding),
        .ID_src1(staged_reg_file_ID_out1),
        .ID_src2(staged_reg_file_ID_out2),

        .MEM_wb_en(wb_en_hazard_MEM_out),
        .MEM_dst(dest_hazard_MEM_out),

        .WB_wb_en(wb_enable_WB_out),
        .WB_dst(wb_dest_WB_out),
        
        .sel_src1(EXE_alu_mux_sel_src1),
        .sel_src2(EXE_alu_mux_sel_src2),
        .ignore_hazard(ignore_hazard_forwarding_out)
    );

    status_register status_register(
        .clk(clk), .rst(rst),
        .ld(status_w_en_EXE_out),
        .data_out(status_reg_ID_in),
        .data_in(status_reg_EXE_out)
    );

endmodule