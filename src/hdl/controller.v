module controller(clk, rst, start, count_done, clear, count_en, done, vga_start, len0, len1, len2, sel);
  /********Controller Interface*******/
  input wire clk, rst;
  input wire start, count_done;
  output wire clear, done, vga_start, count_en, len0, len1, len2;
  output wire [1:0] sel;
  /***********************************/
  
  
  //Combinantional
  wire [2:0] ps;
  wire A, B, C, D, E;
  assign A = ps[2];
  assign B = ps[1];
  assign C = ps[0];
  assign D = start;
  assign E = count_done;

  wire Ap, Cp, Bp, Ep;
  not(Ap, A);
  not(Cp, C);
  not(Bp, B);
  not(Ep, E);
  
  wire ApC, ACp, BC, AB, ApCp, BpC, BpCp, BCp, AEp, AC;
  wire ABCp, ApBpCp, ApBpC, ApCpD, ACpEp;

  // count_en
  and(ApC, Ap, C);
  and(ACp, A, Cp);
  or(count_en, B, ApC, ACp);


  
  //sel[0]
  and(BC, B, C);
  and(AB, A, B);
  or(sel[0], BC, AB);
  
  //sel[1]
  assign sel[1] = A;
  
  //len0
  and(ApCp, Ap, Cp);
  and(BpC, Bp, C);
  or(len0, ApCp, BpC);

  //len1
  and(ABCp, AB, Cp);
  or(len1, ApC, ABCp);

  //len2
  and(BpCp, Bp, Cp);
  assign len2 = BpCp;

  //done / clear
  and(ApBpCp, Ap, Bp, Cp);
  assign done = ApBpCp;
  assign clear = ApBpCp;

  //vga_start
  and(ApBpC, Ap, Bp, C);
  assign vga_start = ApBpC;

  //ns :
  wire [2:0] ns;
 
  //ns[0]
  and(BCp, B, Cp);
  and(ApCpD, Ap, Cp, D);
  and(ACpEp, A, Cp, Ep);
  or(ns[0], BCp, ApCpD, ACpEp);

  //ns[1]
  or(ns[1], BpC, BCp);

  //ns[2]
  and(AEp, A, Ep);
  and(AC, A, C);
  or(ns[2], BC, AEp, AC, AB);
  //=>26 gates<=//
  
  
  //Sequential
  flipflop f1(ns[0], clk, rst, ps[0]);
  flipflop f2(ns[1], clk, rst, ps[1]);
  flipflop f3(ns[2], clk, rst, ps[2]);
  
  
endmodule 