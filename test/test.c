void loop();
//asm(".ORG 0x7f00");
void write_string(colour, string );
main() {
  char colour='\7';
  char *string = "hello sdcsdc sdcsdcsdcl \n";
  //   char *video = (char*)0xB800;
  //   while( *string != 0 )
  //   {
  //       *video++ = *string++;
  //       *video++ = colour;
  //   }
  *((int*)0xb8000)=0x0748;
  *((int*)0xb8002)=0x0769;

  //loop();
write_string(colour, string );
return;
}

void write_string(colour, string ) int colour; char *string; {
    char video =0xb8000;
    while( 1 )
    {
        *((char*)video) = 'c';
        //*((char*)0xb8000++) = '\7';
    }
}

void loop()
{
  asm("jmp _loop");
}
