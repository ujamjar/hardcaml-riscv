module O = interface
    DRAM_ADDR[13] DRAM_BA[2] DRAM_CAS_N[1] 
    DRAM_CKE[1] DRAM_CLK[1] DRAM_CS_N[1]
    DRAM_DQM[2] DRAM_RAS_N[1] DRAM_WE_N[1]
end

module T = interface DRAM_DQ[16] end

