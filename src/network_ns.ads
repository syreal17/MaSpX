with Gnat.Sockets;
with Ada.Exceptions;
with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Streams;
with SPARK.Text_IO; use SPARK.Text_IO;

with network_types; use Network_Types;
with Http_Message; use Http_Message;
with config; use config;
with utils; use utils;
with measured_buffer; use measured_buffer;
with error; use error;

package network_ns 
with SPARK_Mode => On
is

   STATIC_TEST_RESPONSE_11 : constant String := "HTTP/1.1 200 OK" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Date: Mon, 27 Jul 2009 12:28:53 GMT" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Server: MaSp09" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "ETag: '34aa387-d-1568eb00'" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Accept-Ranges: bytes" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Content-Length: 51" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Vary: Accept-Encoding" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Content-Type: text/plain" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF &
                                             "Hello World! My payload includes a trailing CRLF." & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF;
   STATIC_RESPONSE_HEADER_09 : constant String := "HTTP/0.9 200 OK" & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF;
   STATIC_RESPONSE_CONTENT_LENGTH_HEADER_09 : constant String := "Content-Length:";
   STATIC_RESPONSE_ACCEPT_RANGES_HEADER_09 : constant String := "Accept-Ranges: bytes";
   STATIC_RESPONSE_CONTENT_TYPE_09 : constant String := "Content-Type: ";
   STATIC_TEST_RESPONSE_09 : constant String := "Hello World! My payload includes a trailing CRLF." & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF;

   subtype MRB_First_Empty_Index_Type is Natural range Natural'First .. MAX_REQUEST_LINE_BYTE_CT;
   subtype Simple_Request_Line is String(1 .. MAX_REQUEST_LINE_BYTE_CT);

   --TODO: ltj: delete this unused stuff
   --ltj: this will probably be expanded to have headers in it in future implementations of later HTTP
   type Measured_Request_Buffer is
   record
      Buffer : Simple_Request_Line := (others => ' ');
      Length : MRB_First_Empty_Index_Type := 0;
   end record;
   
   --constant tokens for parsing aid
   GET_TOKEN_STR : constant String := "GET";

   procedure Initialize_TCP_State(
      Server_Socket : out Gnat.Sockets.Socket_Type;
      Exception_Raised : out Boolean
   );
   
   procedure Get_Client_Cxn(
      Server_Socket : Gnat.Sockets.Socket_Type;
      Client_Socket : out Gnat.Sockets.Socket_Type;
      Exception_Raised : out Boolean
   );
   
   procedure Recv_NET_Request(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Request : out Measured_Buffer_Type;
      Exception_Raised : out Boolean
   )
   with Global => (In_Out => Standard_Output),
        Post => (if not Exception_Raised then
                    not Is_Empty(Request) and Request.Length <= Request.Size);
   
   procedure Send_TEST_Response(
      Client_Socket : Gnat.Sockets.Socket_Type
      --Message_Byte_Array : Network_Types.Byte_Array_Type
   );
   
   --TODO: Response : Simple_HTTP_Response
   procedure Send_Simple_Response(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Response : Simple_HTTP_Response
   );
   
   procedure Close_Client_Socket(
      Client_Socket : GNAT.Sockets.Socket_Type
   );

end network_ns;
