with Gnat.Sockets;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Streams;

with utils_ns;
with network_types; use Network_Types;
with Http_Message; use Http_Message;
with fileio; use fileio;

package network_ns 
with SPARK_Mode => On
is

   HTTP_PORT : constant Natural := 80;
   MAX_CXNS : constant Natural := 16; --arbitrary
   MAX_REQUEST_LINE_CT : constant Natural := 259;  -- RFC1945:5.1 3 for Method (always GET) 1 for Space, 255 for request-uri

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
   STATIC_TEST_RESPONSE_09 : constant String := "Hello World! My payload includes a trailing CRLF." & ada.Characters.Latin_1.CR & ada.Characters.Latin_1.LF;
   STATIC_UNKNOWN_METHOD_RESPONSE_09 : constant String := "<p>MaSpX error! Unknown HTTP METHOD</p><hr /><p><em>&copy; htmlg.com</em></p>";

   subtype Simple_Request_Line is String(1 .. MAX_REQUEST_LINE_CT);

   --ltj: this will probably be expanded to have headers in it in future implementations of later HTTP
   type Measured_Request_Buffer is
   record
      Buffer : Simple_Request_Line := (others => ' ');
      Length : Natural := 0;
   end record;
   
   --constant tokens for parsing aid
   BLANK_TOKEN_REQUEST_LINE : constant Simple_Request_Line := (others=>' ');
   GET_TOKEN_REQUEST_LINE : constant Simple_Request_Line :=   ('G', 'E', 'T', others=>' ');

   procedure Initialize_TCP_State(
      Server_Socket : out Gnat.Sockets.Socket_Type;
      Server_Socket_Addr : out Gnat.Sockets.Sock_Addr_Type
   );
   
   procedure Get_Client_Cxn(
      Server_Socket : Gnat.Sockets.Socket_Type;
      Client_Socket : out Gnat.Sockets.Socket_Type;
      Client_Socket_Addr : out Gnat.Sockets.Sock_Addr_Type
   );
   
   procedure Recv_NET_Request(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Request : out Measured_Request_Buffer
   );
   
   procedure Send_TEST_Response(
      Client_Socket : Gnat.Sockets.Socket_Type
      --Message_Byte_Array : Network_Types.Byte_Array_Type
   );
   
   --TODO: Response : Simple_HTTP_Response
   procedure Send_Simple_Response(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Response : Simple_HTTP_Response
   );

end network_ns;
