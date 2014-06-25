//LINETRIS - A game using the 4 in line mechanic with features 
//reminding the pieces of the classic game tetris
//by Teresa Paulino
//4-06-2012
//v.1.10

//global variables

int columns = 7;
int rows = 6;
float gravity = 2; //gravity used in class Token to increase speed

int token = 1; //token information, will be 1 or 2 corresponding to player 1 and player 2
//by default game will start with player 1

float x;//x coordinate used to create each new token in order to know to what column belongs
float xCoord; //x coordinate used to drag the token by the mouse
float columnPosition; //used to create the new token in order to know the right place in each column
int[][] positionInfo = new int[columns][rows];//very important array where stores the information
//of every element already played, will vary between 0, 1, 2 (0=empty, 1=player1, 2=player2)

int column;// variable used to help indicates the column information
int gameAction = 0;//indicates when the game starts

ArrayList tokens; // ArrayList that will be used to store each Token (check class Token)
int level = 0;//variable that will give the level info (7 levels available)
int player1 = 0;//player 1 score
int player2 = 0;//player 2 score
PFont font;
color playerColor1 = color(28, 153, 22);
color playerColor2 = color(163, 33, 21);
int retryLevel = 0;//if nobody wins a level, this variable will help to informe that the same level will be restarted
int winer;//who is the final winer (1 or 2)
int endGame = 0;//variable that informs the end of the game in order to make all ready to restart all over


void setup()
{
  size (500,350);//window size
  background (0);//background color
  image( loadImage( "base.png"), width/2, height/2);
  imageMode (CENTER);//read coordinantes in center mode
  tokens = new ArrayList();//initialize the ArrayList tokens;
  font = loadFont("Ziggurat-32.vlw");//font load from data folder
  
  //attributing initial value 0 in all elements of the array positionInfo, so all starts
  //with empty spaces
  for (int i = 0; i < columns; i++)
  {
    for (int j = 0; j < rows; j++)
    {
      positionInfo[i][j] = 0;
    }
  } 
}

void draw()
{
  //2 different ways of initializing, from the begining, or retrying a level, in the
  //2 situations, a different picture will be displayed and the game goes on
  if (retryLevel == 0)
  {
    if (level == 0)
    {
      initial();// calling the initial() function that displays the initial image
    }
    else if (level >= 1)
    {
      game();// calling the game() function with the basic mechanic of the game
    }
  }
  else if (retryLevel == 1)//if nobody won last level
  {
    image(loadImage("retry.png"), width/2, height/2);//displays the retry image
  }
}

//function initial()
void initial()
{
  image(loadImage("initial.png"), width/2, height/2);
  endGame = 0;
}

// when mouse is pressed
void mousePressed()
{//action that will work only if the game is runing
  if (gameAction >= 1)
  {//check availability to place each token
    if (positionInfo[column][5]!=0)
    {//if a column is already filled, displays a message
      println("pleace choose another column");
      columnPosition = -height;
    }
    else if (positionInfo[column][4]!=0)
    {
      columnPosition = height-250;
      positionInfo[column][5] = token;
    }
    else if (positionInfo[column][3]!=0)
    {
      columnPosition = height-200;
      positionInfo[column][4] = token;
    }
    else if (positionInfo[column][2]!=0)
    {
      columnPosition = height-150;
      positionInfo[column][3] = token;
    }
    else if (positionInfo[column][1]!=0)
    {
      columnPosition = height-100;
      positionInfo[column][2] = token;
    }
    else if (positionInfo[column][0]!=0)
    {
      columnPosition = height-50;
      positionInfo[column][1] = token;
    }
    else
    {
      columnPosition = height;
      positionInfo[column][0] = token;
    }
    
   //after getting the information, create a new element in the ArrayList
   tokens.add(new Token(columnPosition, token, x, 25));
   
   //evaluates depending in wich level the game is
   if (level == 1)
   {
     evaluation1();
   }
   else if (level == 2)
   {
     evaluation2();
   }
   else if (level == 3)
   {
     evaluation3();
   }
   else if (level == 4)
   {
     evaluation4();
   }
    else if (level == 5)
   {
     evaluation5();
   }
   else if (level == 6)
   {
     evaluation6();
   }
   else if (level == 7)
   {
     evaluation7();
   }
  
  //if all the spaces are filled and nobody won, displays a message in order to restart
  //the same level
   if (tokens.size() >= 42)
   {
     gameAction = 0;
     retryLevel = 1;
    }
  
    //procedure that will alternate players
    if (columnPosition > 0)
    {
      if (token == 1)
      {
        token = 2;
      }
      else
      {
        token = 1;
      }
     }
   }
}

//when mouse is moved
void mouseMoved()
{
  if (gameAction >= 1)//only when game is runing
  {//according to mouse coordinates, sets the variables x and column
    if (mouseX < 100)
    {
      x = 75;
      column = 0;
    }
    else if (mouseX > 100 && mouseX < 150)
    {
      x = 125;
      column = 1;
    }
    else if (mouseX > 150 && mouseX < 200)
    {
      x = 175;
      column = 2;
    }
    else if (mouseX > 200 && mouseX < 250)
    {
      x = 225;
      column = 3;
    }
     else if (mouseX > 250 && mouseX < 300)
    {
      x = 275;
      column = 4;
    }
    else if (mouseX > 300 && mouseX < 350)
    {
      x = 325;
      column = 5;
    }
    else 
    {
      x = 375;
      column = 6;
    }
    //loads the token image depending of x coordinates
    image(loadImage(token + ".png"), xCoord, 25);
    
  }
}

//game mechanic
void game()
{
  background (0); //clean the background each time is excuted
  image( loadImage( "base.png"), width/2, height/2);
  //apply limits to drag token along mouse
  if (mouseX < 75)
  {
    xCoord = 75;
  }
  else if (mouseX > 75 && mouseX < 375)
  {
    xCoord = mouseX;
  }
  else
  {
    xCoord = 375;
  }
  //displays the token dragged by the mouse
  image(loadImage(token + ".png"), xCoord, 25);
  
  //execute class Token the number of times that was already updated  
  for (int i=0; i<tokens.size(); i++)
  {
    Token tokenInfo = (Token) tokens.get(i);
    tokenInfo.gravity();
    tokenInfo.move();
    tokenInfo.display();
  }
  
  //always load the table image in front
  image(loadImage("boardlevel" + level + ".png"), width/2, height/2); 
  
  //players'scores information always on the screen
  textFont (font, 16);
  
  fill (playerColor1);
  text ("Player 1" , 410, 40);
  text (player1, 445, 65);
  
  fill (playerColor2);
  text ("Player 2" , 410, 100);
  text (player2, 445, 125);
  
  //if the game is not runing and is still not in the last level, check if it's a retry of 
  //a level, if not, display who won the level
  if (gameAction == 0)
  {
    if (level < 7) 
    {
      if (retryLevel == 0)
      {
        image( loadImage( "win"+token+"level"+level+".png"), width/2, height/2);
      }
    }
    
    //if it was the end of the last level, check again if it is to retry this level, if not, 
    //checks who is the final winner and displays the correspondant winer image
    else if (level == 7)
    {
      if (retryLevel == 0)
      {
        if ( player1 > player2)
        {
          winer = 1;
        }
        else if (player1 < player2)
        {
          winer = 2;
        }
      image ( loadImage( "winer"+winer+".png"), width/2, height/2);
      
      //give the information of the end of the game and resets the players'scores
      endGame = 1;
      player1 = 0;
      player2 = 0;
      }
    }
  }
}

//when a key is pressed
void keyPressed()
{
  if (key == ENTER)
  {//if the end of the game was reached, reset level
    if (endGame == 1)
    {
      level = 0;
    }
    else 
    {//if the game is not runing, checks if is a level retry or not
      if (gameAction == 0)
      {
         if (retryLevel == 0)
         {
           level = level + 1;
         }
         else if (retryLevel == 1)
         {
           level = level;
         }
       //resets the array poisitionInfo all to 0 again to start in a clear board
       for (int i = 0; i < columns; i++)
       {
         for (int j = 0; j < rows; j++)
         {
           positionInfo[i][j] = 0;
         }
       }
       
       //remove tokens from the arraylist tokens
       for (int i = tokens.size()-1; i >= 0; i--)
       {
         tokens.remove(i);
       } 
       
       //set all ready to restart
       gameAction = 1;
       retryLevel = 0;
       background (255); 
     }
    }
  }
}


//evaluation of the level 1, the mechanic is to check each neighbour
//till reach the shape required
void evaluation1()
{
  for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j < 6; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+2][j] )
        {
          println("player " + token + " wins");
          addScore(); //function applyed always when someone wins
        }
       }
     }
   }
   //checks all possibilities depending of the position of the shape required
   for (int i=0; i<5;i++)
   {
     for (int j=0; j<4;j++)
     {
       if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j+1] )
       {
         if (positionInfo[i+1][j+1] == positionInfo[i+2][j+2] )
         {
           println("player " + token + " wins");
           addScore();
         }
       }
    }
   }
   for (int i=0; i<7; i++)
   {
     for (int j=0; j<4; j++)
     {
       if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i][j+1] )
       {
         if (positionInfo[i][j+1] == positionInfo[i][j+2] )
         {
           println("player " + token + " wins");
           addScore();
         }
        }
      }
    }
}

//evaluation of the level 2, similar procedure as in the previous evaluation according to the shape required
void evaluation2()
{
 for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j < 5; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+1][j+1] )
        {
          if (positionInfo[i+1][j+1] == positionInfo[i+2][j+1] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
      if ( positionInfo[i][j+1]!=0 &&  positionInfo[i][j+1] == positionInfo[i+1][j+1] )
      {
        if (positionInfo[i+1][j+1] == positionInfo[i+1][j] )
        {
          if (positionInfo[i+1][j] == positionInfo[i+2][j] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
    }
  }
  for (int i = 0; i < 6; i++)
  {
    for (int j = 0; j < 4; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i][j+1] )
      {
        if (positionInfo[i][j+1] == positionInfo[i+1][j+1] )
        {
          if (positionInfo[i+1][j+1] == positionInfo[i+1][j+2] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
      if ( positionInfo[i][j+1]!=0 &&  positionInfo[i][j+1] == positionInfo[i+1][j+1] )
      {
        if (positionInfo[i+1][j+1] == positionInfo[i][j+2] )
        {
          if (positionInfo[i][j+2] == positionInfo[i+1][j] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
    }
  } 
}
    
//evaluation of the level 3, similar procedure as in the previous evaluation according to the shape required 
void evaluation3()
{
  for (int i = 0; i < 4; i++)
  {
    for (int j = 0; j < 6; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+2][j] )
        {
          if (positionInfo[i+2][j] == positionInfo[i+3][j] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
    }
  }
  for (int i=0; i<4;i++)
  {
    for (int j=0; j<3;j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j+1] )
      {
        if (positionInfo[i+1][j+1] == positionInfo[i+2][j+2] )
        {
          if ( positionInfo[i+2][j+2] == positionInfo[i+3][j+3] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
    }
  }
  for (int i=0; i<7; i++)
  {
    for (int j=0; j<3; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i][j+1] )
      {
        if (positionInfo[i][j+1] == positionInfo[i][j+2] )
        {
          if (positionInfo[i][j+2] == positionInfo[i][j+3] )
          { 
            println("player " + token + " wins");
            addScore();
          }
        }
      }
    }
  }
}

//evaluation of the level 4, similar procedure as in the previous evaluation according to the shape required
void evaluation4()
{
  for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j < 4; j++)
    {
      if ( positionInfo[i+1][j]!=0 &&  positionInfo[i+1][j] == positionInfo[i][j+1] )
      {
        if (positionInfo[i][j+1] == positionInfo[i+1][j+1] )
        {
          if (positionInfo[i+1][j+1] == positionInfo[i+2][j+1] )
          { 
            if (positionInfo[i+2][j+1] == positionInfo[i+1][j+2] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
    }
  }
}

//evaluation of the level 5, similar procedure as in the previous evaluation according to the shape required
void evaluation5()
{
  for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j < 4; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+2][j] )
        {
          if (positionInfo[i+2][j] == positionInfo[i+1][j+1] )
          { 
            if (positionInfo[i+1][j+1] == positionInfo[i+1][j+2] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i][j+1] )
      {
        if (positionInfo[i][j+1] == positionInfo[i][j+2] )
        {
          if (positionInfo[i][j+2] == positionInfo[i+1][j+1] )
          { 
            if (positionInfo[i+1][j+1] == positionInfo[i+2][j+1] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
      if ( positionInfo[i+2][j]!=0 &&  positionInfo[i+2][j] == positionInfo[i+2][j+1] )
      {
        if (positionInfo[i+2][j+1] == positionInfo[i+1][j+1] )
        {
          if (positionInfo[i+1][j+1] == positionInfo[i][j+1] )
          { 
            if (positionInfo[i][j+1] == positionInfo[i+2][j+2] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
      if ( positionInfo[i+1][j]!=0 &&  positionInfo[i+1][j] == positionInfo[i+1][j+1] )
      {
        if (positionInfo[i+1][j+1] == positionInfo[i+1][j+2] )
        {
          if (positionInfo[i+1][j+2] == positionInfo[i][j+2] )
          { 
            if (positionInfo[i][j+2] == positionInfo[i+2][j+2] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
    }
  }
}

//evaluation of the level 6, similar procedure as in the previous evaluation according to the shape required
void evaluation6()
{
  for (int i = 0; i < 5; i++)
  {
    for (int j = 0; j < 5; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+2][j] )
        {
          if (positionInfo[i+2][j] == positionInfo[i][j+1] )
          { 
            if (positionInfo[i][j+1] == positionInfo[i+2][j+1] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i][j+1] )
      {
        if (positionInfo[i][j+1] == positionInfo[i+1][j+1] )
        {
          if (positionInfo[i+1][j+1] == positionInfo[i+2][j+1] )
          { 
            if (positionInfo[i+2][j+1] == positionInfo[i+2][j] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
    }
  }
  for (int i = 0; i < 6; i++)
  {
    for (int j = 0; j < 4; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i][j+1] )
        {
          if (positionInfo[i][j+1] == positionInfo[i][j+2] )
          { 
            if (positionInfo[i][j+2] == positionInfo[i+1][j+2] )
            {
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+1][j+1] )
        {
          if (positionInfo[i+1][j+1] == positionInfo[i+1][j+2] )
          { 
            if (positionInfo[i+1][j+2] == positionInfo[i][j+2] )
            {
              println("player " + token + " wins");
               addScore();
            }
          }
        }
      }
    }
  }
}

//evaluation of the level 7, similar procedure as in the previous evaluation according to the shape required
void evaluation7()
{
  for (int i = 0; i < 3; i++)
  {
    for (int j = 0; j < 6; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j] )
      {
        if (positionInfo[i+1][j] == positionInfo[i+2][j] )
        {
          if (positionInfo[i+2][j] == positionInfo[i+3][j] )
          { 
            if (positionInfo[i+3][j] == positionInfo[i+4][j] )
            { 
              println("player " + token + " wins");
              addScore();
             }
           }
        }
      }
    }
  }
  for (int i=0; i<3; i++)
  {
    for (int j=0; j<2; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i+1][j+1] )
      {
        if (positionInfo[i+1][j+1] == positionInfo[i+2][j+2] )
        {
          if ( positionInfo[i+2][j+2] == positionInfo[i+3][j+3] )
          { 
            if ( positionInfo[i+3][j+3] == positionInfo[i+4][j+4] )
            {
              println("player " + token + " wins");
              addScore();       
            }
          }
        }
      }
      if ( positionInfo[i][j+4]!=0 &&  positionInfo[i][j+4] == positionInfo[i+1][j+3] )
      {
        if (positionInfo[i+1][j+3] == positionInfo[i+2][j+2] )
        {
          if ( positionInfo[i+2][j+2] == positionInfo[i+3][j+1] )
          { 
            if ( positionInfo[i+3][j+1] == positionInfo[i+4][j] )
            {
              println("player " + token + " wins");
              addScore();      
             }
          }
        }
      }
    }
  }
  for (int i=0; i<7; i++)
  {
    for (int j=0; j<2; j++)
    {
      if ( positionInfo[i][j]!=0 &&  positionInfo[i][j] == positionInfo[i][j+1] )
      {
        if (positionInfo[i][j+1] == positionInfo[i][j+2] )
        {
          if (positionInfo[i][j+2] == positionInfo[i][j+3] )
          { 
            if (positionInfo[i][j+3] == positionInfo[i][j+4] )
            { 
              println("player " + token + " wins");
              addScore();
            }
          }
        }
      }
    }
  }
}      

//procedure when a player wins
void addScore()
{//the game stops
  gameAction = 0;
  //addscore to the player ad change again the player to the next 
  //turn so will be the same to start the next level
  if (token == 1)
  {
    player1 = player1 + 1;
    token = 2;
  }
  else
  {
    player2 = player2 + 1;
    token = 1;
  }
  println("player1 score: " + player1);
  println("player2 score: " + player2);  
}
