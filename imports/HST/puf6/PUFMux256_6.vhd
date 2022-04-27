library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity PUFMux256_6 is
port(
i_D : in std_logic_vector(255 downto 0); -- Data value input
i_Sel : in std_logic_vector(7 downto 0);
o_Q : out std_logic -- Data value output
);
end PUFMux256_6;

architecture structural of PUFMux256_6 is

begin

with i_Sel select
	o_Q <= i_D(0) when "00000000",
		i_D(1) when "00000001",
		i_D(2) when "00000010",
		i_D(3) when "00000011",
		i_D(4) when "00000100",
		i_D(5) when "00000101",
		i_D(6) when "00000110",
		i_D(7) when "00000111",
		i_D(8) when "00001000",
		i_D(9) when "00001001",
		i_D(10) when "00001010",
		i_D(11) when "00001011",
		i_D(12) when "00001100",
		i_D(13) when "00001101",
		i_D(14) when "00001110",
		i_D(15) when "00001111",
		i_D(16) when "00010000",
		i_D(17) when "00010001",
		i_D(18) when "00010010",
		i_D(19) when "00010011",
		i_D(20) when "00010100",
		i_D(21) when "00010101",
		i_D(22) when "00010110",
		i_D(23) when "00010111",
		i_D(24) when "00011000",
		i_D(25) when "00011001",
		i_D(26) when "00011010",
		i_D(27) when "00011011",
		i_D(28) when "00011100",
		i_D(29) when "00011101",
		i_D(30) when "00011110",
		i_D(31) when "00011111",
		i_D(32) when "00100000",
		i_D(33) when "00100001",
		i_D(34) when "00100010",
		i_D(35) when "00100011",
		i_D(36) when "00100100",
		i_D(37) when "00100101",
		i_D(38) when "00100110",
		i_D(39) when "00100111",
		i_D(40) when "00101000",
		i_D(41) when "00101001",
		i_D(42) when "00101010",
		i_D(43) when "00101011",
		i_D(44) when "00101100",
		i_D(45) when "00101101",
		i_D(46) when "00101110",
		i_D(47) when "00101111",
		i_D(48) when "00110000",
		i_D(49) when "00110001",
		i_D(50) when "00110010",
		i_D(51) when "00110011",
		i_D(52) when "00110100",
		i_D(53) when "00110101",
		i_D(54) when "00110110",
		i_D(55) when "00110111",
		i_D(56) when "00111000",
		i_D(57) when "00111001",
		i_D(58) when "00111010",
		i_D(59) when "00111011",
		i_D(60) when "00111100",
		i_D(61) when "00111101",
		i_D(62) when "00111110",
		i_D(63) when "00111111",
		i_D(64) when "01000000",
		i_D(65) when "01000001",
		i_D(66) when "01000010",
		i_D(67) when "01000011",
		i_D(68) when "01000100",
		i_D(69) when "01000101",
		i_D(70) when "01000110",
		i_D(71) when "01000111",
		i_D(72) when "01001000",
		i_D(73) when "01001001",
		i_D(74) when "01001010",
		i_D(75) when "01001011",
		i_D(76) when "01001100",
		i_D(77) when "01001101",
		i_D(78) when "01001110",
		i_D(79) when "01001111",
		i_D(80) when "01010000",
		i_D(81) when "01010001",
		i_D(82) when "01010010",
		i_D(83) when "01010011",
		i_D(84) when "01010100",
		i_D(85) when "01010101",
		i_D(86) when "01010110",
		i_D(87) when "01010111",
		i_D(88) when "01011000",
		i_D(89) when "01011001",
		i_D(90) when "01011010",
		i_D(91) when "01011011",
		i_D(92) when "01011100",
		i_D(93) when "01011101",
		i_D(94) when "01011110",
		i_D(95) when "01011111",
		i_D(96) when "01100000",
		i_D(97) when "01100001",
		i_D(98) when "01100010",
		i_D(99) when "01100011",
		i_D(100) when "01100100",
		i_D(101) when "01100101",
		i_D(102) when "01100110",
		i_D(103) when "01100111",
		i_D(104) when "01101000",
		i_D(105) when "01101001",
		i_D(106) when "01101010",
		i_D(107) when "01101011",
		i_D(108) when "01101100",
		i_D(109) when "01101101",
		i_D(110) when "01101110",
		i_D(111) when "01101111",
		i_D(112) when "01110000",
		i_D(113) when "01110001",
		i_D(114) when "01110010",
		i_D(115) when "01110011",
		i_D(116) when "01110100",
		i_D(117) when "01110101",
		i_D(118) when "01110110",
		i_D(119) when "01110111",
		i_D(120) when "01111000",
		i_D(121) when "01111001",
		i_D(122) when "01111010",
		i_D(123) when "01111011",
		i_D(124) when "01111100",
		i_D(125) when "01111101",
		i_D(126) when "01111110",
		i_D(127) when "01111111",
		i_D(128) when "10000000",
		i_D(129) when "10000001",
		i_D(130) when "10000010",
		i_D(131) when "10000011",
		i_D(132) when "10000100",
		i_D(133) when "10000101",
		i_D(134) when "10000110",
		i_D(135) when "10000111",
		i_D(136) when "10001000",
		i_D(137) when "10001001",
		i_D(138) when "10001010",
		i_D(139) when "10001011",
		i_D(140) when "10001100",
		i_D(141) when "10001101",
		i_D(142) when "10001110",
		i_D(143) when "10001111",
		i_D(144) when "10010000",
		i_D(145) when "10010001",
		i_D(146) when "10010010",
		i_D(147) when "10010011",
		i_D(148) when "10010100",
		i_D(149) when "10010101",
		i_D(150) when "10010110",
		i_D(151) when "10010111",
		i_D(152) when "10011000",
		i_D(153) when "10011001",
		i_D(154) when "10011010",
		i_D(155) when "10011011",
		i_D(156) when "10011100",
		i_D(157) when "10011101",
		i_D(158) when "10011110",
		i_D(159) when "10011111",
		i_D(160) when "10100000",
		i_D(161) when "10100001",
		i_D(162) when "10100010",
		i_D(163) when "10100011",
		i_D(164) when "10100100",
		i_D(165) when "10100101",
		i_D(166) when "10100110",
		i_D(167) when "10100111",
		i_D(168) when "10101000",
		i_D(169) when "10101001",
		i_D(170) when "10101010",
		i_D(171) when "10101011",
		i_D(172) when "10101100",
		i_D(173) when "10101101",
		i_D(174) when "10101110",
		i_D(175) when "10101111",
		i_D(176) when "10110000",
		i_D(177) when "10110001",
		i_D(178) when "10110010",
		i_D(179) when "10110011",
		i_D(180) when "10110100",
		i_D(181) when "10110101",
		i_D(182) when "10110110",
		i_D(183) when "10110111",
		i_D(184) when "10111000",
		i_D(185) when "10111001",
		i_D(186) when "10111010",
		i_D(187) when "10111011",
		i_D(188) when "10111100",
		i_D(189) when "10111101",
		i_D(190) when "10111110",
		i_D(191) when "10111111",
		i_D(192) when "11000000",
		i_D(193) when "11000001",
		i_D(194) when "11000010",
		i_D(195) when "11000011",
		i_D(196) when "11000100",
		i_D(197) when "11000101",
		i_D(198) when "11000110",
		i_D(199) when "11000111",
		i_D(200) when "11001000",
		i_D(201) when "11001001",
		i_D(202) when "11001010",
		i_D(203) when "11001011",
		i_D(204) when "11001100",
		i_D(205) when "11001101",
		i_D(206) when "11001110",
		i_D(207) when "11001111",
		i_D(208) when "11010000",
		i_D(209) when "11010001",
		i_D(210) when "11010010",
		i_D(211) when "11010011",
		i_D(212) when "11010100",
		i_D(213) when "11010101",
		i_D(214) when "11010110",
		i_D(215) when "11010111",
		i_D(216) when "11011000",
		i_D(217) when "11011001",
		i_D(218) when "11011010",
		i_D(219) when "11011011",
		i_D(220) when "11011100",
		i_D(221) when "11011101",
		i_D(222) when "11011110",
		i_D(223) when "11011111",
		i_D(224) when "11100000",
		i_D(225) when "11100001",
		i_D(226) when "11100010",
		i_D(227) when "11100011",
		i_D(228) when "11100100",
		i_D(229) when "11100101",
		i_D(230) when "11100110",
		i_D(231) when "11100111",
		i_D(232) when "11101000",
		i_D(233) when "11101001",
		i_D(234) when "11101010",
		i_D(235) when "11101011",
		i_D(236) when "11101100",
		i_D(237) when "11101101",
		i_D(238) when "11101110",
		i_D(239) when "11101111",
		i_D(240) when "11110000",
		i_D(241) when "11110001",
		i_D(242) when "11110010",
		i_D(243) when "11110011",
		i_D(244) when "11110100",
		i_D(245) when "11110101",
		i_D(246) when "11110110",
		i_D(247) when "11110111",
		i_D(248) when "11111000",
		i_D(249) when "11111001",
		i_D(250) when "11111010",
		i_D(251) when "11111011",
		i_D(252) when "11111100",
		i_D(253) when "11111101",
		i_D(254) when "11111110",
		i_D(255) when others;
	
end structural;
