# --
# Copyright 2007 Nominet UK
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ++

require_relative 'spec_helper'

include Dnsruby
class TestPacket < Minitest::Test
  def test_packet
    domain = "example.com."
    type = "MX"
    klass = "IN"

    packet = Message.new(domain, type, klass)

    assert(packet,                                 'new() returned something');         #2
    assert(packet.header,                         'header() method works');            #3
    assert_instance_of(Header,packet.header,'header() returns right thing');     #4


    question = packet.question;
    assert(question && question.length == 1,             'question() returned right number of items'); #5
    #       assert_instance_of(Net::DNS::Question,question[0], 'question() returned the right thing');       #6

    answer = packet.answer;
    assert(answer.length == 0,     'answer() works when empty');     #7


    authority = packet.authority;
    assert(authority.length == 0,  'authority() works when empty');  #8

    additional = packet.additional;
    assert(additional.length == 0, 'additional() works when empty'); #9

    packet.add_answer(RR.create(   {
          :name    => "a1.example.com.",
          :type    => Types.A,
          :address => "10.0.0.1"}));
    assert_equal(1, packet.header.ancount, 'First push into answer section worked');      #10


    ret = packet.answer.rrset("example.com.", 'NSEC')
    assert_equal(ret.rrs.length, 0, "#{ret.rrs.length}")
    ret = packet.answer.rrset("a1.example.com", 'A')
    assert_equal(ret.rrs.length, 1, "#{ret.rrs.length}")
    ret = packet.answer.rrsets()
    assert_equal(ret.length, 1, "#{ret.length}")

    packet.add_answer(RR.create({:name    => "a2.example.com.",
          :type    => "A", :address => "10.0.0.2"}));
    assert_equal(packet.header.ancount, 2, 'Second push into answer section worked');     #11

    packet.add_authority(RR.create({:name    => "a3.example.com.",
          :type    => "A",
          :address => "10.0.0.3"}));
    assert_equal(1, packet.header.nscount, 'First push into authority section worked');   #12


    packet.add_authority(RR.create( {
          :name    => "a4.example.com.",
          :type    => "A",
          :address => "10.0.0.4"}));
    assert_equal(2, packet.header.nscount, 'Second push into authority section worked');  #13

    packet.add_additional(RR.create({
          :name    => "a5.example.com.",
          :type    => "A",
          :address => "10.0.0.5"}));
    assert_equal(1, packet.header.adcount, 'First push into additional section worked');  #14

    packet.add_additional(RR.create(  {
          :name    => "a6.example.com.",
          :type    => Types.A,
          :address => "10.0.0.6"}));
    assert_equal(2, packet.header.adcount, 'Second push into additional section worked'); #15

    data = packet.encode;

    packet2 = Message.decode(data);

    assert(packet2, 'new() from data buffer works');   #16

    assert_equal(packet.to_s, packet2.to_s, 'inspect() works correctly');  #17


    string = packet2.to_s
    6.times do |count|
      ip = "10.0.0.#{count+1}";
      assert(string =~ /#{ip}/,  "Found #{ip} in packet");  # 18 though 23
    end

    assert_equal(1, packet2.header.qdcount, 'header question count correct');   #24
    assert_equal(2, packet2.header.ancount, 'header answer count correct');     #25
    assert_equal(2, packet2.header.nscount, 'header authority count correct');  #26
    assert_equal(2, packet2.header.adcount, 'header additional count correct'); #27



    #  Test using a predefined answer. This is an answer that was generated by a bind server.
    # 

    #       data=["22cc85000001000000010001056461636874036e657400001e0001c00c0006000100000e100025026e730472697065c012046f6c6166c02a7754e1ae0000a8c0000038400005460000001c2000002910000000800000050000000030"].pack("H*");
    uuencodedPacket =%w{
22 cc 85 00 00 01 00 00 00 01 00 01 05 64 61 63
68 74 03 6e 65 74 00 00 1e 00 01 c0 0c 00 06 00
01 00 00 0e 10 00 25 02 6e 73 04 72 69 70 65 c0
12 04 6f 6c 61 66 c0 2a 77 54 e1 ae 00 00 a8 c0
00 00 38 40 00 05 46 00 00 00 1c 20 00 00 29 10
00 00 00 80 00 00 05 00 00 00 00 30
    }

    uuencodedPacket = %w{
ba 91 81 80 00 01
00 04 00 00 00 01 07 65 78 61 6d 70 6c 65 03 63
6f 6d 00 00 ff 00 01 c0 0c 00 02 00 01 00 02 9f
f4 00 14 01 61 0c 69 61 6e 61 2d 73 65 72 76 65
72 73 03 6e 65 74 00 c0 0c 00 02 00 01 00 02 9f
f4 00 04 01 62 c0 2b c0 0c 00 01 00 01 00 02 9f
7e 00 04 d0 4d bc a6 c0 0c 00 06 00 01 00 02 9f
f4 00 31 04 64 6e 73 31 05 69 63 61 6e 6e 03 6f
72 67 00 0a 68 6f 73 74 6d 61 73 74 65 72 c0 6e
77 a1 2d b7 00 00 1c 20 00 00 0e 10 00 12 75 00
00 01 51 80 00 00 29 05 00 00 00 00 00 00 00
    }
    uuencodedPacket.map!{|e| e.hex}
    packetdata = uuencodedPacket.pack('c*')

    packet3 = Message.decode(packetdata)
    assert(packet3,                                 'new data returned something');         #28

    assert_equal(packet3.header.qdcount, 1, 'header question count in syntetic packet correct');   #29
    assert_equal(packet3.header.ancount, 4, 'header answer count in syntetic packet correct');     #30
    assert_equal(packet3.header.nscount, 0, 'header authority count in syntetic packet  correct'); #31
    assert_equal(packet3.header.adcount, 1, 'header additional in sytnetic  packet correct');      #32

    rr=packet3.additional;

    assert_equal(Types.OPT, rr[0].type, "Additional section packet is EDNS0 type");                         #33
    assert_equal(1280, rr[0].klass.code, "EDNS0 packet size correct");                                     #34

    #  In theory its valid to have multiple questions in the question section.
    #  Not many servers digest it though.

    packet.add_question("bla.foo", Types::TXT, Classes.CH)
    question = packet.question
    assert_equal(2, question.length,             'question() returned right number of items poptest:2'); #36
  end

  def get_test_packet
    packet=Message.new("254.9.11.10.in-addr.arpa.","PTR","IN")

    packet.add_answer(RR.create(%q[254.9.11.10.in-addr.arpa. 86400 IN PTR host-84-11-9-254.customer.example.com.]));

    packet.add_authority(RR.create("9.11.10.in-addr.arpa. 86400 IN NS autons1.example.com."));
    packet.add_authority(RR.create("9.11.10.in-addr.arpa. 86400 IN NS autons2.example.com."));
    packet.add_authority(RR.create("9.11.10.in-addr.arpa. 86400 IN NS autons3.example.com."));
    return packet
  end


  def test_push
    packet = get_test_packet
    data=packet.encode

    packet2=Message.decode(data)

    assert_equal(packet.to_s,packet2.to_s,"Packet decode and encode");  #39
  end

  def test_rrset
    packet = get_test_packet
    packet.each_section do |section|
      #      print "#{section.rrsets}\n"
    end
    packet.section_rrsets.each do |section, rrsets|
      #       print "section = #{section}, rrsets = #{rrsets.length}\n"
    end
    assert(packet.authority.rrsets.length == 1)
    assert(packet.question().length == 1)
    assert(packet.answer.rrsets.length == 1)
    assert(packet.additional.rrsets.length == 0)
    assert(packet.authority.rrsets[0].length == 3)
    #     assert(packet.additional.rrsets[0].length == 0)
    assert(packet.answer.rrsets[0].length == 1)
  end

  def test_section
    packet = Message.new("ns2.nic.se")
    packet.add_answer(RR.create("ns2.nic.se.		3600 IN	A 194.17.45.54"))
    packet.add_answer(RR.create("ns2.nic.se.		3600 IN	RRSIG A 5 3 3600 20090329175503 (
				20090319175503 32532 nic.se.
				YFvEOPpVHgAmPwtM2Q0KD5x6UaZ5bMzINMyW4xXSXOxG
				/EYCTbmTfPpfZTnAUPAfNRIA4RS9etMgh5Zy3Wug4dKs
				20+3vwlSz0Ge5jluOoowkWAK3YbLkqwSi1DeZg/HT1Ns
				zcBDHMJ9sxmB6d4nuRA6653w9RULVjpKng1gh0s= )
        "))
    packet.add_authority(RR.create("nic.se.			3600 IN	NS ns2.nic.se."))
    packet.add_authority(RR.create("nic.se.			3600 IN	NS ns3.nic.se."))
    packet.add_authority(RR.create("nic.se.			3600 IN	NS ns.nic.se."))
    packet.add_authority(RR.create("nic.se.			3600 IN	RRSIG NS 5 2 3600 20090329175503 (
				20090319175503 32532 nic.se.
				ZExPKC9zDiyY0TuuPGDBtzYE119fiXWqihARO41l7uTT
				LBbYcCNg3ItJZW2y0o4iFYpqrp62l25uKhO4cMEZbgZs
				Gq9B6zZ4/2D0v4zFjlzCEZ0lTrGb6xgOrnQbZUiTbg46
				x9iBai7Ud1w/hgV/TSxikP1SS0J1AillybPiMWQ= )"))
    packet.add_additional(RR.create("ns.nic.se.		3600 IN	A 212.247.7.228"))
    packet.add_additional(RR.create("ns.nic.se.		3600 IN	AAAA 2a00:801:f0:53::53"))
    packet.add_additional(RR.create("ns3.nic.se.		60 IN A	212.247.3.83"))
    packet.add_additional(RR.create("ns.nic.se.		3600 IN	RRSIG A 5 3 3600 20090329175503 (
				20090319175503 32532 nic.se.
				opTtrYBF+Mm4BGK+5vvAvzxxgh4GUxa7YxflT1DybG7u
				uRdi+ZD6+DFXvaMKPcmVLRcMV2wEv7v1zBj+jaAkqPno
				ikOHMtd9g0FtmfxR//TLLzgjDsunee0MX6hLX/ApTUy8
				hhcGB1pxk371tZKSBkNI7SN7gaSnknUUEp6eNN4= )"))
    packet.add_additional(RR.create("ns.nic.se.		3600 IN	RRSIG AAAA 5 3 3600 20090329175503 (
				20090319175503 32532 nic.se.
				Qaj/eG9MPGF6QZUPpRq3LBxfxQiKki3J2myKy+OQuE65
				juDBb+29YjteqQW1PrilxRjo4apX5Q4LNAhS+bEx+PNU
				dHr8x0u7z7fZMCAaZhQndnWTD5Wzf1J97bt0ml78yqDi
				PkYeqNTNeM0Y40VTu0aHsPPPZpQRR7MYcODUbl0= )"))
    packet.add_additional(RR.create("ns3.nic.se.		60 IN RRSIG A 5 3 60 20090329175503 (
				20090319175503 32532 nic.se.
				Ql7Msgt0HKDifPaCV8UYsiLj7hOEp6LPJJ5oaFrJhooU
				Nrp4gcwlX9QbrYXWQ8cgE0Z+bL2c07EX/f+n7+xfgCIu
				UtL1tXJPsujZBojMtpnkbZsCb5cQmUv0CjAVIdF82W7Q
				mUg/YzRLeIyl/wBm0u8/v7TZp/KbGbaKMWMXkjo= )"))
    packet.add_additional(RR::OPT.new(4096, 0x9e22))
    packet.header.aa = true

    assert(packet.answer.length == 2)
    assert(packet.authority.length == 4)
    assert(packet.additional.length == 7)

    ns3_a_rrset = packet.additional.rrset("ns3.nic.se", "A")
    assert(ns3_a_rrset.length == 2)

    section_rrsets = packet.section_rrsets
    assert(section_rrsets["answer"].length == 1)
    assert(section_rrsets["authority"].length == 1)
    assert(section_rrsets["additional"].length == 3)

    add_count = 0
    packet.each_additional {|rr| add_count += 1}
    assert(add_count == 7)

    packet.additional.remove_rrset(Name.create("ns.nic.se."), Types.AAAA)
    assert(packet.answer.length == 2)
    assert(packet.authority.length == 4)
    assert(packet.additional.length == 5)
    section_rrsets = packet.section_rrsets
    assert(section_rrsets["answer"].length == 1)
    assert(section_rrsets["authority"].length == 1)
    assert(section_rrsets["additional"].length == 2)

    add_count = 0
    packet.each_additional {|rr| add_count += 1}
    assert(add_count == 5)

    packet.additional.remove_rrset(Name.create("ns.nic.se."), Types.A)
    assert(packet.answer.length == 2)
    assert(packet.authority.length == 4)
    assert(packet.additional.length == 3)
    section_rrsets = packet.section_rrsets
    assert(section_rrsets["answer"].length == 1)
    assert(section_rrsets["authority"].length == 1)
    assert(section_rrsets["additional"].length == 1)

    packet.additional.remove_rrset(Name.create("ns3.nic.se."), Types.A)
    assert(packet.answer.length == 2)
    assert(packet.authority.length == 4)
    assert(packet.additional.length == 1)
    section_rrsets = packet.section_rrsets
    assert(section_rrsets["answer"].length == 1)
    assert(section_rrsets["authority"].length == 1)
    assert(section_rrsets["additional"].length == 0)
  end

  def test_clone
    m = Message.new("blah.example.com", "DNSKEY", "IN")
    m.header.rcode=4
    m2 = m.clone
    assert_equal(m.to_s, m2.to_s, "Clone to_s failed")
    assert_equal(m, m2, "Clone failed")
  end
end
