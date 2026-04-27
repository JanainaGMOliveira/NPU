module MultiplierSigned(
    output [31:0] oP,
    input  [7:0]  iA,
    input  [15:0] iB
);
    wire [15:0] complementA, complementB;
    wire [31:0] complementP;

    TwosComplement #(16) c1(complementA, {iA[7], iA[7], iA[7], iA, 5'b0}, iA[7]);
    TwosComplement #(16) c2(complementB, iB, iB[15]);

    Multiplier16b m(complementP, complementA, complementB);

    TwosComplement #(32) c3(oP, complementP, (iA[7] ^ iB[15])); // complemento de 2 do produto
endmodule

module Multiplier16b(
    output [31:0] oP,
    input  [15:0] iA,
    input  [15:0] iB
);
    wire [15:0] m1, m2, m3, m4, m5, m6;
    wire c;

    assign oP[7:0]  = m1[7:0];
    assign oP[15:8] = m6[7:0];

    Multiplier8b mul1(m1, iA[7:0],  iB[7:0]);
    Multiplier8b mul2(m2, iA[15:8], iB[7:0]);
    Multiplier8b mul3(m3, iA[7:0],  iB[15:8]);
    Multiplier8b mul4(m4, iA[15:8], iB[15:8]);

    Adder #(16) a1(m5,        c,  m2,         m3         );
    Adder #(16) a2(m6,         ,  m5, {8'b0, m1[15:8]}   );
    Adder #(16) a3(oP[31:16],  ,  m4, {7'b0, c, m6[15:8]});
endmodule

module Multiplier8b(
    output [15:0] oP,
    input  [7:0]  iA,
    input  [7:0]  iB
);
    wire [7:0] m1, m2, m3, m4, m5, m6;
    wire c;

    assign oP[3:0] = m1[3:0];
    assign oP[7:4] = m6[3:0];

    Multiplier4b mul1(m1, iA[3:0], iB[3:0]);
    Multiplier4b mul2(m2, iA[7:4], iB[3:0]);
    Multiplier4b mul3(m3, iA[3:0], iB[7:4]);
    Multiplier4b mul4(m4, iA[7:4], iB[7:4]);

    Adder #(8) a1(m5,       c, m2,         m3        );
    Adder #(8) a2(m6,        , m5, {4'b0, m1[7:4]}   );
    Adder #(8) a3(oP[15:8],  , m4, {3'b0, c, m6[7:4]});
endmodule

module Multiplier4b(
    output [7:0] oP,
    input  [3:0] iA,
    input  [3:0] iB
);
    wire s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;
    wire aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9, aux10, aux11, aux12, aux13, aux14, aux15;
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13;

    // P0
    and a00(oP[0], iA[0], iB[0]);

    // P1
    xor x00(oP[1], (iA[0] & iB[1]), (iA[1] & iB[0]));

    // P2
    and a01(s1, iA[0], iA[1], iB[0], iB[1]);
    and a02(s2, iA[2], iB[0]);
    and a03(s3, iA[1], iB[1]);
    and a04(s4, iA[0], iB[2]);
    HA  h01(aux1,  c1, s4,   s3  );
    HA  h02(aux2,  c2, s2,   s1  );
    HA  h03(oP[2], c3, aux1, aux2);

    // P3
    HA  h04(s6,    c5, (iA[0] & iB[3]), (iA[1] & iB[2]));
    HA  h05(s5,    c4, (iA[3] & iB[0]), (iA[2] & iB[1]));
    HA  h06(aux3,  c6,        s5,              s6      );
    HA  h07(oP[3], c7,       aux3,             s7      );
    xor x01(s7, c1, c2, c3);

    // P4
    HA  h08(s9,    c9, (iA[2] & iB[2]),     (iA[3] & iB[1]));
    HA  h09(s8,    c8, (s1 & s2 & s3 & s4), (iA[1] & iB[3]));
    HA  h10(aux4,  c10,         s8,                s9      );
    HA  h11(oP[4], c11,        aux4,              s10      );
    xor x02(s10, c4, c5, c6, c7);

    // P5
    or  o00(aux5, (c4 & c5), (c4 & s6 & s7), (s7 & c5 & s5));
    xor x03(aux6, (iA[3] & iB[2]), (iA[2] & iB[3]));
    HA  h12(aux7,  c12, aux5,          aux6        );
    HA  h13(oP[5], c13, aux7, (c8 ^ c9 ^ c10 ^ c11));

    // P6 e P7
    HA h14(aux12, aux13, (iA[3] & iB[3]), (iA[2] & iB[2] & iA[3] & iB[3]));
    HA h15(aux11, aux14,       c12,                    aux12             );
    HA h16(aux9,  aux10,      aux11,                   aux8              );
    HA h17(oP[6], aux15,      aux9,                    c13               );
    or o01(aux8,  (c8 & c9), (c8 & s9 & s10), (s10 & c9 & s8));
    or o02(oP[7], aux15,     (aux10 | (aux13 | aux14)));
endmodule