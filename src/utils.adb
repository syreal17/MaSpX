pragma SPARK_Mode(On);

package body utils is

   procedure Debug_Print_Ln(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success and DEBUG_PRINT_ON then
         Put_Line(String_To_Print);
      end if;
   end Debug_Print_Ln;

   procedure Debug_Print(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success and DEBUG_PRINT_ON then
         Put(String_To_Print);
      end if;
   end Debug_Print;
   
   procedure Check_Print_Ln(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success then
         Put_Line(String_To_Print);
      end if;
   end Check_Print_Ln;

   procedure Check_Print(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success then
         Put(String_To_Print);
      end if;
   end Check_Print;

end utils;