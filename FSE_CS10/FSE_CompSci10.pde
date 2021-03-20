import processing.sound.*;
SoundFile theme;
boolean[] keys=new boolean[128];//for when the keys are pressed
int gameMode=0;//0-main menu 1-play 2-how to play 3-character select

//main menu vairables
PImage title;//logo
PImage mainBackground;//background for main menu
int menuChoice=1;//1-play 2-controls 3-charater selection

//playing variables
float level=1;//which level the user is on, 0.5 for boss battle

//arrays for all character animations
PImage[] mario=new PImage[4];
PImage[] luigi=new PImage[4];
PImage[] gold=new PImage[4];
PImage[] toad=new PImage[4];
PImage[] cat=new PImage[4];
PImage[] furry=new PImage[4];
PImage[] frog=new PImage[4];
PImage[] yoshi=new PImage[4];
PImage[] goldYoshi=new PImage[4];
PImage[] fireYoshi=new PImage[4];
PImage[] character=mario;

PImage[] enemies1=new PImage[7];
PImage[] enemies2=new PImage[7];//each enemy animation has two frames
IntList enemy=new IntList();//which enemy is shown
FloatList ex=new FloatList();//enemy x position
FloatList ey=new FloatList();//enemy x position
int lives=5;//how many lives the player has
PImage life;//image of lives

FloatList bx=new FloatList();//bullet's x pos
FloatList by=new FloatList();//bullet's y pos

float frame=0;//what frame 
float bgX=0;//x position of background
float characterY=460;//y position of character
float JUMPPOWER=-18.0;//how high the character can jump
float vy=0.0;//velocity
boolean onGround=true;//whether the character is on the ground

//background for the levels
PImage level1BG;
PImage level2BG;
PImage level3BG;
PImage level4BG;
PImage level5BG;

//boss battle
PImage bossBG;
float speed=5;//speed of boss' bullet
float bossY=random(420);//random y position of the boss
PImage fly;//the platform the character will be standing on
int startTime;
int maxTime;
int passedTime;
FloatList bbx=new FloatList();//x position of boss' bullet
FloatList bby=new FloatList();//y position of boss' bullet
//bosses
PImage boss2;
PImage boss3;
PImage boss3Bullet;
PImage boss4;
PImage boss4Bullet;
PImage boss5;
PImage boss5Bullet;

PImage gameOver;
PImage win;

//how to play vairables
PImage HTPbg;//background
//pictures on the screen
PImage upArrow;
PImage rightArrow;
PImage space;

//character select variables
PImage select_bg;
//shows which character is currently selected
int rectX=120;// x position of the rectangle that shows which character is currently selected
int rectY=130;

//foward-facing picture of all characters
PImage mario_char;
PImage luigi_char;
PImage gold_char;
PImage toad_char;
PImage cat_char;
PImage furry_char;
PImage frog_char;
PImage yoshi_char;
PImage goldYoshi_char;
PImage fireYoshi_char;

void createArrays(){
  for(int i=0;i<4;i++){
    mario[i]=loadImage("mario"+nf(i,3)+".png");
    luigi[i]=loadImage("luigi"+nf(i,3)+".png");
    gold[i]=loadImage("gold-mario"+nf(i,3)+".png");
    toad[i]=loadImage("toad"+nf(i,3)+".png");
    cat[i]=loadImage("cat"+nf(i,3)+".png");
    furry[i]=loadImage("furry"+nf(i,3)+".png");
    frog[i]=loadImage("frog"+nf(i,3)+".png");
    yoshi[i]=loadImage("yoshi"+nf(i,3)+".png");
    goldYoshi[i]=loadImage("gold-yoshi"+nf(i,3)+".png");
    fireYoshi[i]=loadImage("fire-yoshi"+nf(i,3)+".png");
  }
  
  for(int i=0;i<enemies1.length;i++){
    enemies1[i]=loadImage("enemy"+nf(i+1,2)+".png");
    enemies2[i]=loadImage("enemy"+(i+1)+".png");
  }
}

void setup(){
  size(800,600);
  stroke(0,255,0);
  theme=new SoundFile(this,"Mario-Theme-Song.mp3"); 
  theme.loop();//plays throughout gameplay
  
  title=loadImage("MarioName.png");
  mainBackground=loadImage("background.png");
  
  createArrays();
  life=loadImage("life.png");
  
  //level backgrounds
  level1BG=loadImage("level1_bg.png");
  level2BG=loadImage("level2_bg.png");
  level3BG=loadImage("level3_bg.png");
  level4BG=loadImage("level4_bg.png");
  level5BG=loadImage("level5_bg.png");
  
  bossBG=loadImage("bg.png");
  fly=loadImage("float.png");
  startTime=millis();
  boss2=loadImage("Boss2.png");
  boss3=loadImage("boss3.png");
  boss3Bullet=loadImage("boss3_bullet.png");
  boss4=loadImage("Boss4.png");
  boss4Bullet=loadImage("boss4_bullet.png");
  boss5=loadImage("bowser.png");
  boss5Bullet=loadImage("boss5_bullet.png");
  
  gameOver=loadImage("Game_over.png");
  win=loadImage("you-win.png");
  
  //How to play pictures
  HTPbg=loadImage("HTPbackground.png");
  upArrow=loadImage("upArrow.png");
  rightArrow=loadImage("rightArrow.png");  
  space=loadImage("Space_key.png");
  
  //Character Select pictures
  select_bg=loadImage("select-bg.png");
  mario_char=loadImage("mario.png");
  luigi_char=loadImage("luigi.png");
  gold_char=loadImage("gold-mario.png");
  toad_char=loadImage("toad.png");
  cat_char=loadImage("cat.png");
  furry_char=loadImage("furry.png");
  frog_char=loadImage("frog.png");
  yoshi_char=loadImage("yoshi.png");
  goldYoshi_char=loadImage("gold-yoshi.png");
  fireYoshi_char=loadImage("fire-yoshi.png");
  
  frameRate(15);//slow enough to see the animation and fast enough to make the game fun
}

void backToMain(){
  textSize(20);
  textAlign(LEFT);
  strokeWeight(1);
  text("Back to main",30,575);
 
  if(mouseX>20 && mouseX<170 && mouseY>545 && mouseY<615){//when the mouse is near the words
    fill(159, 75, 16);
    stroke(0);
    rect(20,545,150,50);
    fill(255);
    text("Back to main",30,575);
    
    if(mousePressed){//resets all playing() variables
      gameMode=0;//goes back to main menu
      level=1;
      bgX=0;
      characterY=460;
      vy=0;
      lives=5;
    }
  }
}

void mainMenu(){  
  textAlign(CENTER);
  image(mainBackground,0,0,800,600);//background image
  
  image(title,width/2-150,110,300,75);//puts the title in the middle
  textSize(35);
  fill(0);
  text("Play",150,280);
  text("How to Play", width/2,280);
  text("Characters",650,280);
  
  textSize(20);
  text("CLICK to select",width/2,575);
    
  if(mouseX>=115 && mouseX<=185 && mouseY>=250 && mouseY<=285)//users click to select
    gameMode=1;
  if(mousePressed && mouseX>=300 && mouseX<=500 && mouseY>=250 && mouseY<=285)
    gameMode=2;
  if(mousePressed && mouseX>=555 && mouseX<=740 && mouseY>=250 && mouseY<=285)
    gameMode=3; 
}

void movePlayer(){
  if (keys[38] && onGround){//can jump ONLY if on ground
      vy=JUMPPOWER;
      onGround=false;
  }
  
  characterY+=vy;//moving up/down
  
  if (characterY>=460){//ground
     vy=0;   //stop falling
     characterY=460; //set the y position to 450 (ground)
     onGround=true;
  }
    
  if(keys[39]){//right arrow makes it move forward
    bgX+=10;
    frame++;
    if(frame>=4){
      frame=1;
    }
    if(onGround)
      image(character[int(frame)],384,characterY,30,60);
    else{
      image(character[0],384,characterY,30,60);
    }//else
  }//if(keys[39]
  
  else if(!onGround){
    image(character[0],384,characterY,30,60);
  }
  
  else{
    image(character[1],384,characterY,30,60);
  }//else
  
  if(!onGround)
    vy++;
}//movePlayer

boolean hitBox(int r1x,int r1y,int r1w,int r1h,int r2x,int r2y,int r2w,int r2h){
 
  int r1Bot,r1Right;
  int r2Bot,r2Right;
  r1Right=r1x+r1w;
  r1Bot=r1y+r1h;
  
  r2Right=r2x+r2w;
  r2Bot=r2y+r2h;
    
  if(r1Right > r2x && r1x < r2Right && r1Bot > r2y && r1y < r2Bot){
    return true;
  }
 
  return false;
}

void showLives(){//number of hearts shown
  for(int i=0;i<lives;i++){
    image(life,i*25+20,20,26,22);
  }
}

void bullets(){
  if(keys[32]){//space bar
    if(level==1 || level==2 || level==3 ||level==4 ||level==5)//normal levels
      bx.append(395);
    else if(level==2.5 || level==3.5 ||level==4.5 ||level==5.1 ||level==5.2)//boss battles
      bx.append(70);
    by.append(characterY+40);
  }

  fill(255);
  strokeWeight(1);
  stroke(0);
  for(int i=0;i<bx.size();i++){
    ellipse(bx.get(i),by.get(i),10,10);//a circle for each bullet
  }//for(int i...

  for(int i=0;i<bx.size();i++){
    bx.add(i,10);//moving bullet
    if(bx.get(i)>805){
      bx.remove(i);
      by.remove(i);
    }//if(bx.get(i)... 
  }//for(int i...  
}//bullets()

void checkHit(){
  for(int i=0;i<ex.size();i++){
    if(hitBox(384,int(characterY),30,60,int(ex.get(i)),int(ey.get(i)),50,50)){//if the enemy hits the character
      lives--;
      ex.remove(i);
      ey.remove(i);
      enemy.remove(i);
    }
    
    for(int j=0;j<bx.size();j++){
      if(bx.size()!=0 && ex.size()!=0){ 
        if(bx.get(j)>ex.get(i)){
          if((by.get(j)-10>ey.get(i)&&by.get(j)-10<ey.get(i)+50) || (by.get(j)+10>ey.get(i)&&by.get(j)+10<ey.get(i)+50)){//if the bullet hits the enemy
            ex.remove(i);
            ey.remove(i);
            bx.remove(j);
            by.remove(j);
            enemy.remove(i);
          }//if((by.get(i)-10...
        }//if(bx.get(i)>...
      }//if(bx.size()...
    }//for(int j...
  }//for(int i...  
}//checkHit()

void level1(){
  image(level1BG,-bgX,0);
  showLives();
  
  if (hitBox(int(bgX),int(characterY),30,60,400,425,400,75)){//first step
   if (vy>0 && !hitBox(int(bgX),int(characterY-vy),30,60,400,425,400,75)){
     vy=0;//stop falling 
     characterY=385;//the player is exactly standing on the platform
     onGround=true;
    }
  }
  
  else if (hitBox(int(bgX),int(characterY),30,60,490,360,255,75)){
   if (vy>0 && !hitBox(int(bgX),int(characterY-vy),30,60,490,360,255,75)){
     vy=0;
     characterY=315;
     onGround=true;
    }
  }
  
  else if (hitBox(int(bgX),int(characterY),30,60,560,295,125,75)){
   if (vy>0 && !hitBox(int(bgX),int(characterY-vy),30,60,560,295,125,75)){
     vy=0;
     characterY=242;
     onGround=true;
    }
  } 
  
  else{
    vy++;
  }
  
  if(bgX>390 && bgX<=810 && characterY<=460 && characterY>385){//so that the character doesn't walk through the step
    bgX=390;
  }
  if(bgX>=455 && bgX<=740 && characterY<=385 && characterY>315){
    bgX=455;
  } 
  if(bgX>=525 && bgX<=680 && characterY<=315 && characterY>242){
    bgX=525;
  }
  
  if(bgX>955){//setup the next level
    level=2;
    bgX=0;//reset background to 0
    enemy.append(floor(random(7)));//random enemy
    enemy.append(floor(random(7)));
    ex.append(850);//first enemy will appear when the character is 50 away from the beginning
    ex.append(1610);
    ey.append(470);//on ground
    ey.append(315);//on platform
  }
}

void level2(){
  image(level2BG,-bgX,0);
  bullets();
  showLives();
  checkHit();

  for(int i=0;i<ex.size();i++){
    if(keys[39]){//the enemy moves only when the arrow is pressed so that it enters at the right time
      ex.add(i,-5);
    }
    if(ex.get(i)%20==0)
      image(enemies1[enemy.get(i)],ex.get(i),ey.get(i),50,50);
    else{
      image(enemies2[enemy.get(i)],ex.get(i),ey.get(i),50,50);
    }
    if(bgX>50 && bgX<810){
      ex.add(i,-5);//so that it moves without pressing the right arrow
    }
    if(bgX>810 && bgX<1200){
      ex.add(i,-5);
    }

    else if(ex.get(i)<-50){//enemy is off screen
      enemy.remove(i);
      ex.remove(i);
      ey.remove(i);
    }
  } 
  
  if(hitBox(int(bgX),int(characterY),30,60,810,350,800,90)){
    if (vy>0 && !hitBox(int(bgX),int(characterY-vy),30,60,810,350,800,90)){
     vy=0;  
     characterY=305;
     onGround=true;
    }
  }
  
  if(bgX>=780 && bgX<=1615 && characterY<=460 && characterY>305){
    bgX=780;
  }

  if(bgX>1200){
    level=2.5; 
    bgX=0;
    characterY=435;
    bx.clear();
    by.clear();
    ex.clear();
    ey.clear();
    frameRate(100);//boss battles are faster
  } 
}

void bossBattle2(){
  image(bossBG,0,0,800,600);
  showLives();
  
  if(keys[38])
    characterY-=10;
  if(keys[40])
    characterY+=10;
  if(characterY<=45)
    characterY=45;
  if(characterY>=435)
    characterY=435;
    
  bossY-=speed;
  if(bossY>420 || bossY<0)
     speed*=-1;//changes directions
   
  image(character[1],50,characterY,30,60);
  image(fly,51,characterY+60,30,15);
  image(boss2,680,bossY,100,100);
  bullets();
  
  for(int i=0;i<bx.size();i++){
    if(bx.get(i)>680){
      if((by.get(i)-10>bossY&&by.get(i)-10<bossY+100) || (by.get(i)+10>bossY&&by.get(i)+10<bossY+100)){
        bx.clear();
        by.clear();
        level=3;
        characterY=460;
        bgX=0;
        frameRate(15);
      }//if((by.get(i)...
    }//if(be.get(i)...
  }//for(int i=0...
}//bossBattle2()

void level3(){
  image(level3BG,-bgX,0);
  showLives();
  bullets();
  
  if(hitBox(int(bgX),int(characterY),30,60,340,460,50,50)){
    lives--;
    bgX=300;
  }
  if(hitBox(int(bgX),int(characterY),30,60,660,460,50,50)){
    lives--;
    bgX=620;
  }
  if(hitBox(int(bgX),int(characterY),30,60,980,460,50,50)){
    lives--;
    bgX=940;
  }
  if(hitBox(int(bgX),int(characterY),30,60,1300,460,50,50)){
    lives--;
    bgX=1260;
  }
  
  if(bgX>1600){
    level=3.5;
    characterY=435;
    bgX=0;
    frameRate(100);
  }
}

void bossBattle3(){
  image(bossBG,0,0,800,600);
  showLives();
  
  if(keys[38])
    characterY-=10;
  if(keys[40])
    characterY+=10;
  if(characterY<=45)
    characterY=45;
  if(characterY>=435)
    characterY=435;
    
  bossY-=speed;
  if(bossY>420 || bossY<0)
     speed*=-1;
     
  maxTime=5000;//5 seconds
  passedTime=millis()-startTime;
  if(passedTime>maxTime){
    bbx.append(730);
    bby.append(bossY+50);
    startTime=millis();
  }
  for(int i=0;i<bbx.size();i++){
    image(boss3Bullet,bbx.get(i),bby.get(i),20,20);
    bbx.add(i,-5);
    if(hitBox(51,int(characterY),30,60,int(bbx.get(i)),int(bby.get(i)),20,20)){
      lives--;
      bbx.remove(i);
      bby.remove(i);
    }
  }
  
  image(character[1],50,characterY,30,60);
  image(fly,51,characterY+60,30,15);
  image(boss3,680,bossY,100,100);
  bullets();
  
  for(int i=0;i<bx.size();i++){
    if(bx.get(i)>680){
      if((by.get(i)-10>bossY&&by.get(i)-10<bossY+100) || (by.get(i)+10>bossY&&by.get(i)+10<bossY+100)){
        bx.clear();
        by.clear();
        bbx.clear();
        bby.clear();
        level=4;
        characterY=460;
        bgX=0;
        frameRate(15);
        for(int j=0;j<10;j++){
          enemy.set(j,floor(random(7)));
          ex.set(j,random(750,2400));
          ey.set(j,470);
        }//for(int j=0...
      }//if((by.get(i)...
    }//if(bx.get(i)...
  }//for(int i=0...
}//bossBattle3()

void level4(){
  image(level4BG,0,0);
  showLives();
  bullets();
  checkHit();
  
  for(int i=0;i<ex.size();i++){
    if(keys[39])
      ex.add(i,-5);
    if(millis()%2==0)
      image(enemies1[enemy.get(i)],ex.get(i),ey.get(i),50,50);
    else{
      image(enemies2[enemy.get(i)],ex.get(i),ey.get(i),50,50);
    }
    if(ex.get(i)<800)
      ex.add(i,-5);
  }
  
  if(ex.size()==0 || bgX==1600){
    level=4.5;
    characterY=435;
    bgX=0;
    frameRate(100);
    ex.clear();
    ey.clear();
  }
}

void bossBattle4(){
  image(bossBG,0,0,800,600);
  showLives();
  
  if(keys[38])
    characterY-=10;
  if(keys[40])
    characterY+=10;
  if(characterY<=45)
    characterY=45;
  if(characterY>=435)
    characterY=435;
     
  maxTime=4000;//5 seconds
  passedTime=millis()-startTime;
  if(passedTime>maxTime){
    bbx.append(750);
    bby.append(bossY+50);
    bossY=random(420);
    startTime=millis();
  }
  for(int i=0;i<bbx.size();i++){
    image(boss4Bullet,bbx.get(i),bby.get(i),20,20);
    bbx.add(i,-5);
    if(hitBox(51,int(characterY),30,60,int(bbx.get(i)),int(bby.get(i)),20,20)){
      lives--;
      bbx.remove(i);
      bby.remove(i);
    }
  }
  
  image(character[1],50,characterY,30,60);
  image(fly,51,characterY+60,30,15);
  image(boss4,700,bossY,100,100);
  bullets();
  
  for(int i=0;i<bx.size();i++){
    if(bx.get(i)>700){
      if((by.get(i)-10>bossY&&by.get(i)-10<bossY+100) || (by.get(i)+10>bossY&&by.get(i)+10<bossY+100)){
        bx.clear();
        by.clear();
        bbx.clear();
        bby.clear();
        ex.clear();
        ey.clear();
        enemy.clear();
        level=5;
        characterY=460;
        bgX=0;
        frameRate(15);
        for(int j=0;j<3;j++){
          ex.append((j*500)+750);
          ey.append(470);
          enemy.append(floor(random(7)));
        }
      }//if((by.get(i)...
    }//if(be.get(i)...
  }//for(int i=0...
}//bossBattle4()

void level5(){
  image(level5BG,-bgX,0);
  showLives();
  checkHit();
  bullets();
  
  if(hitBox(int(bgX),int(characterY),30,60,110,460,50,50)){
    if (vy>0 && !hitBox(int(bgX),int(characterY-vy),30,60,110,460,50,50)){
     vy=0;  
     characterY=410;
     onGround=true;
    }
  }

  else if(hitBox(int(bgX),int(characterY),30,60,1110,460,50,50)){
    if (vy>0 && !hitBox(int(bgX),int(characterY-vy),30,60,1110,460,50,50)){
     vy=0;  
     characterY=409;
     onGround=true;
    }
  }
  
  else{
    vy++;
  }
  
  if(hitBox(int(bgX),int(characterY),30,60,610,460,50,50)){
    lives--;
    bgX=580;
  }
  
  for(int i=0;i<ex.size();i++){
    if(keys[39])
      ex.add(i,-10);
    if(ex.get(i)%20==0)
      image(enemies1[enemy.get(i)],ex.get(i),ey.get(i),50,50);
    else
      image(enemies2[enemy.get(i)],ex.get(i),ey.get(i),50,50);
  }
  
  if(bgX==1600){
    level=5.1;
    characterY=435;
    bgX=0;
    frameRate(100);
  }
}

void bossBattle5a(){
  image(bossBG,0,0,800,600);
  showLives();
  
  if(keys[38])
    characterY-=10;
  if(keys[40])
    characterY+=10;
  if(characterY<=45)
    characterY=45;
  if(characterY>=435)
    characterY=435;
     
  maxTime=2500;
  passedTime=millis()-startTime;
  if(passedTime>maxTime){
    bbx.append(730);
    bby.append(bossY+50);
    bossY=random(370);
    startTime=millis();
  }
  for(int i=0;i<bbx.size();i++){
    image(boss5Bullet,bbx.get(i),bby.get(i),20,20);
    bbx.add(i,-5);
    if(hitBox(51,int(characterY),30,60,int(bbx.get(i)),int(bby.get(i)),20,20)){
      lives--;
      bbx.remove(i);
      bby.remove(i);
    }
  }
  
  image(character[1],50,characterY,30,60);
  image(fly,51,characterY+60,30,15);
  image(boss5,680,bossY,100,150);
  bullets();
  
  for(int i=0;i<bx.size();i++){
    if(bx.get(i)>680){
      if((by.get(i)-10>bossY&&by.get(i)-10<bossY+150) || (by.get(i)+10>bossY&&by.get(i)+10<bossY+150)){
        bx.clear();
        by.clear();
        level=5.2;
      }//if((by.get(i)...
    }//if(be.get(i)...
  }//for(int i=0...
}//bossBattle5a()

void bossBattle5b(){
  image(bossBG,0,0,800,600);
  showLives();
  
  if(keys[38])
    characterY-=10;
  if(keys[40])
    characterY+=10;
  if(characterY<=45)
    characterY=45;
  if(characterY>=435)
    characterY=435;
    
  bossY-=speed;
  if(bossY>370 || bossY<0)
     speed*=-1;
     
  maxTime=5000;//5 seconds
  passedTime=millis()-startTime;
  if(passedTime>maxTime){
    bbx.append(730);
    bby.append(bossY+50);
    startTime=millis();
  }
  for(int i=0;i<bbx.size();i++){
    image(boss5Bullet,bbx.get(i),bby.get(i),20,20);
    bbx.add(i,-5);
    if(hitBox(51,int(characterY),30,60,int(bbx.get(i)),int(bby.get(i)),20,20)){
      lives--;
      bbx.remove(i);
      bby.remove(i);
    }
  }
  
  image(character[1],50,characterY,30,60);
  image(fly,51,characterY+60,30,15);
  image(boss5,680,bossY,100,150);
  bullets();
  
  for(int i=0;i<bx.size();i++){
    if(bx.get(i)>680){
      if((by.get(i)-10>bossY&&by.get(i)-10<bossY+150) || (by.get(i)+10>bossY&&by.get(i)+10<bossY+150)){
        bx.clear();
        by.clear();
        bbx.clear();
        bby.clear();
        level=6;
        characterY=460;
      }//if((by.get(i)...
    }//if(bx.get(i)...
  }//for(int i=0...
}//bossBattle5b()

void playing(){
  background(0);
  
  if(level==1){
    level1();
    movePlayer();
  }
    
  else if(level==2){
    level2();
    movePlayer();
  }
  
  else if(level==2.5){
    bossBattle2();  
  }
    
  else if(level==3){
    level3();
    movePlayer();
  }
  
  else if(level==3.5){
    bossBattle3();
  }
  
  else if(level==4){
    level4();
    movePlayer();
  }
  
  else if(level==4.5){
    bossBattle4();
  }
  
  else if(level==5){
    level5();
    movePlayer();
  }
  
  else if(level==5.1){//first part of the final boss battle
    bossBattle5a();
  }
  
  else if(level==5.2){//second part of boss battles
    bossBattle5b();
  }
    
  else if(level==6){//end of the game
    image(win,0,0,800,600);
  }

  
  if(lives<=0){//character runs out of lives
    image(gameOver,0,0,800,600);
  }
  
  backToMain();
}

void controls(){//how to play
  image(HTPbg,0,0,800,600);
  textAlign(CENTER);
  textSize(25);
  fill(0);//blak text
  text("The main goal of this game is to complete each level",width/2,100);
  image(rightArrow,width/2-37,110,75,75);
  text("Press the right arrow to move",width/2,200);
  image(upArrow,width/2-37,210,75,75);
  text("Up to jump",width/2,300);
  image(space,width/2-100,320,200,50);
  text("Defeat the enemies by using the space bar to shoot",width/2,410);
  text("Now you can have fun playing!",width/2,475);
  
  backToMain();
}

void select(){//character select
  image(select_bg,0,0,800,600);
  textAlign(LEFT);
  textSize(20);
  fill(0);
  
  image(mario_char,140,150,50,100);
  text("Mario",138,290);
  
  image(luigi_char,250,150,50,100);
  text("Luigi",250,290);
  
  image(yoshi_char,360,150,66,100);
  text("Yoshi",360,290);
  
  image(toad_char,470,150,50,100);
  text("Toad",470,290);
  
  image(cat_char,580,150,60,100);
  text("Mr.Cat",580,290);
  
  image(frog_char,140,380,48,60);
  text("Froggo",130,480);
  
  image(furry_char,250,340,57,100);
  text("Furry",250,480);
  
  image(gold_char,360,340,57,100);
  text("Gold \nMario",360,470);
  
  image(goldYoshi_char,470,340,67,100);
  text("Gold \nYoshi",470,470);
  
  image(fireYoshi_char,580,340,74,100);
  text("Fire \nYoshi",580,470);
  
  noFill();
    
  if(keys[39]){
    rectX+=113;
    if(rectX>572)
      rectX=572;
  }
  if(keys[37]){
    rectX-=113;
    if(rectX<120)
      rectX=120;
  }
  if(keys[40]){
    rectY+=190;
    if(rectY>320)
      rectY=320;
  }
  if(keys[38]){
    rectY-=190;
    if(rectY<130)
      rectY=130;
  }
  stroke(0);
  strokeWeight(3);
  rect(rectX,rectY,90,130);
  
  if(rectX==120 && rectY==130)
    character=mario;
  if(rectX==233 && rectY==130){
    character=luigi;
  }
  if(rectX==346 && rectY==130){
    character=yoshi;
  }
  if(rectX==459 && rectY==130){
    character=toad;
  }
  if(rectX==572 && rectY==130){
    character=cat;
  }
  if(rectX==120 && rectY==320){
    character=frog;
  }
  if(rectX==233 && rectY==320){
    character=furry;
  }
  if(rectX==346 && rectY==320){
    character=gold;
  }
  if(rectX==459 && rectY==320){
    character=goldYoshi;
  }
  if(rectX==572 && rectY==320){
    character=fireYoshi;
  }
  
  fill(255);
  text("Use arrows to navigate",10,590);
  text("Enter to select",640,590);
  
  if(keyPressed && key==ENTER && gameMode==3){
    gameMode=0;
  }
}

void keyPressed(){
  keys[keyCode]=true;

}

void keyReleased(){
  keys[keyCode]=false;
}

void draw(){
  if(gameMode==0)
    mainMenu();
    
  else if(gameMode==1)
    playing();
   
  if(gameMode==2)
    controls();
  
  if(gameMode==3)
    select();
    
  println(bgX+" "+mouseY);
}
