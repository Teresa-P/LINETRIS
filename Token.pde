class Token
{
  float xPos;
  float yPos;
  int player;
  float speed;
  PImage img;
  float position;
  
  //Constructor
  Token(float columnPosition, int token, float x, float y)
  {
    xPos = x;
    yPos = y;
    player = token;
    position = columnPosition;
    img = loadImage(player + ".png");
    speed = 0;
  }
  
  void gravity() 
  {
    // add gravity to speed
    speed = speed + gravity; 
  }
  
  void move()
  {
    yPos = yPos + speed;
    if (yPos> position-25)
    {//decrease velocity
      speed = speed * -0.4;
      yPos = position-25;
      
    }
   }
    
   void display()
   {//displays the token
     image(img, xPos, yPos);
   }
}
//class Token end
