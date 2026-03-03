--declarations
--tables
sparks={}
star={}
flower={}
plant={197, 192, 202}
--plant={201,196,206}
plantx={22,63,103}
recty1={-10,27,33,37,40,44}
recty2={ 25,31,35,38,41,45}
--lorg={"turnip3","turnip4","turnip5"}
--smol=split("turnip1,turnip2,turnip6,turnip7,turnip8,turnip9")
--smol={54,56,34,32,36,160}

num=flr(rnd(6))
--stars
str_start=16
str_cnt=6
str_grav=.6
str_drp=16

--plants
pani1=48
pani2=50
pani3=52

--menu
scene="menu"

--animations
spawn=0
in_air=false
anim=0

--turnips
--1x1
turnip1=54
turnip2=56
turnip6=34
turnip7=32
turnip8=36
turnip9=160
--1x2
turnip3=44
turnip4=42
turnip5=13

--init
function _init()

   music(08,0)
   --init player
   player={
      --player stats
      sp=1,    x=59,   y=59,
      w=8,     h=8,    flp=false,
      dx=0,    dy=0,   max_dx=3,
      max_dy=3,acc=0.5,boost=2.5,
      anim=0,

      --player states
      running=false, jumping=false,
      falling=false, sliding=false,
      landed=false
   }

   --camera
   camx=0
   mapstart=0
   mapend=1024

   --init stars
   starfall()

   --init flowers
   spawn_plant()

   --set physics
   gravity=0.10
   friction=0.6

   --set shake
   offset=0
   yy=0

   -- set particles
   effects = {}

   --particle settings
   firefly_width = 1024
   firefly_colors = {12,13,7}
   firefly_amount = 24

   spark_width = 8
   spark_colors = {9,10,7}
   spark_amount = .5

   spark_width2 = 12
   spark_colors2 = {14,10,7}
   spark_amount2 = 3

   dust_width = 8
   dust_colors = {13,6,5}
   dust_amount = 1

   explode_size = 5
   explode_colors = {14,10,7,14}
   explode_amount = 5

   explode_size2 = 3
   explode_colors2 = {9,10}
   explode_amount2 = 1
   explode_size3 = 10

   --set sfx

   --pollen count
   pollen=0


   ----debug----
   --x1r=1
   --x2r=1
   --y1r=1
   --y2r=1

   --cll="no"
   --clr="no"
   --clu="no"
   --cld="no"
end

---------------------------------------

--menu/states update
function _update60()

   if scene=="menu" then
      update_menu()
      song=08
   elseif scene=="game" then
      update_game()
      song=00
   elseif scene=="pause" then
      update_pause()
   elseif scene=="win" then
      song=10
      update_win()
   end
   update_fx()
end

--menu/states draw
function _draw()
   if scene=="menu" then
      draw_menu()
   elseif scene=="game" then
      draw_game()
   elseif scene=="pause" then
      draw_pause()
   elseif scene=="win" then
      draw_win()
   end
end

---------------------------------------
--menu
function update_menu()
   --launch game
   if btnp(❎) then
      music(00,0)
      scene="game"

   end
end

-- menu draw
function draw_menu()
   --background
   cls(1)
   --draws rects by iterating through tables
   for i=0, 6 do
      rectfill(-10,recty1[i],mapend,recty2[i],0)
   end
   spawn_map()
   map(0,0)



   --title
   outline_text("hakurei",47,30,1,7)
   print("-------",48,36,7)
   rectfill(15,44,115,75,1)
   rect( 15, 44, 115, 75,0)
   print("the flowers call to you!",18,49,6)
   print("lend them your strength",20,58,14)
   print("press",35,67,6,0)
   print("❎",56,68,5)
   print("❎",56,69-1+sin(time()*1.1),6,0)
   print("to start",65,67,6,0)
   
   outline_text("❎=jump 🅾️=release pollen",15,87,7,0)
  -- spr(154,25,15,3,3)
   spr(154,72,15-1+sin(time()*1.5),3,3,0)
   outline_text("music by majeedooo0010",23,115,6,0)
   outline_text("sound effects by fettuccini",12,122,6,0)
  
end

---------------------------------------
--pause
function update_pause()
   if btnp(❎) then
      scene="game"
   end
end

function draw_pause()
   --background
   cls(1)

   for i=0, 6 do
      rectfill(-10,recty1[i],mapend,recty2[i],0)
   end
   spawn_map()
   map(0,0)



   --title
   outline_text("hakurei",47,30,1,7)
   print("-------",48+camx,36,7)

   rectfill(15+camx,44,115+camx,70,1)
   rect( 15+camx, 44, 115+camx, 70,0)
   print("game paused",45+camx,49,6)
   print("press",35+camx,60,6,0)
   print("❎",56+camx,60,5)
   print("❎",56+camx,61-1+sin(time()),6,0)
   print("to start",65+camx,60,6,0)

end

---------------------------------------
--win
function update_win()
   camera(0,0)
   camx=0
   player.x=0
end

function draw_win()
   --background
   cls(0)
   --draw blue sky
   for i=0, 2 do
      map(49,16,i*128,0,15)
   end
   --spawn parallax
   spawn_map()
   --draw ground
   for i=0, 2 do
      map(64,16,i*128,0,16)
   end

   --animate flowers
   if time()-anim>.3 then
      anim=time()
      pani1+=1
      pani2+=1
      pani3+=1
      player.sp+=1

      if pani1>49 then
         pani1=48
      end
      if pani2>51 then
         pani2=50
      end
      if pani3>53 then
         pani3=52
      end
      if player.sp>3 then
         player.sp=1
      end
   end

   outline_sprite(pani2,7,64,13*8,1,1,false,false)
   outline_sprite(pani1,7,48,13*8,1,1,false,false)
   outline_sprite(pani3,7,80,13*8,1,1,false,false)
   outline_sprite(player.sp,0,64,80,1,1,false,false)
   --draw moon
   spr(11,60,3*8-1+flr(sin(time())),2,2)
   --outline
   outline_text("the spirits thank you",21,50,1,7)
end




--game update
function update_game()
   --music
   music_play=true

   --set cam to player pos
   camx=player.x-60

   --limit camera movement
   if camx<mapstart then
      camx=mapstart
   end
   if camx>mapend-128 then
      camx=mapend-128
   end

   --set camera x
   camera(camx,0)

   --update the player
   player_update()
   player_ani()

   --stars
   for str in all(star) do
      --add gravity to stars
      str.y+=str_grav
      -- str collision
      if  str.y+4>player.y-8
      and str.y+4<player.y+8
      and str.x+4>player.x-10
      and str.x+4<player.x+10 then
         del(star,str)
         -- offset=.1
         explode(player.x,player.y,explode_size,explode_colors,explode_amount)
         pollen_count()
         --         pollen_tile()
      end
      --del if at bottom
      if str.y>120 then
         del(star,str)
         explode(str.x,str.y,explode_size2,explode_colors2,explode_amount2)
      end
   end

   --if all stars gone restart
   if #star==0 then
      starfall()
   end
   firefly(player.x,player.y,firefly_width,firefly_colors,firefly_amount)

   --change states
   if btnp(⬆️) then
      scene="pause"
   end

   if  flower[1].age==5
   and flower[2].age==5
   and flower[3].age==5 then
    scene="win"
    music(10,0)
   end

   turnip_count()

end

---------------------------------------
-- draw the game
function draw_game()

   --enable screen shakes
   screen_shake()

   --setup background
   cls(1)
   for i=0, 6 do
      rectfill(-10,recty1[i],mapend,recty2[i],0)
   end

   spawn_map()
   --particles
   draw_fx()
   --draw flowers
   flowerdraw()
   map(0,0)

   --turnips
   turnip_draw1()
   turnip_draw2()
   turnip_draw3()


   --draw player with outline
   outline_sprite(player.sp,0,player.x,player.y,1,1,player.flp,false)

   --draw ui
   draw_counter()

   --draw each star
   for str in all(star) do
      spr(str.sprite,str.x,str.y)
   end

   --draw moon
   spr(11,63*8,3*8-1+flr(sin(time())),2,2)



   --debug--
   -- rect(x1r,y1r,x2r,y2r,7)
   -- print(player.landed,player.x,player.y+10)
   -- print(player.x,player.x,player.y+10)
   -- print(in_air,player.x,player.y+10)
   -- print(player.dy,player.x,player.y+18)
   -- print("⬅️=	"..cll,player.x,player.y-10)
   -- print("➡️=	"..clr,player.x,player.y-16)
   -- print("⬆️=	"..clu,player.x,player.y-22)
   -- print("⬇️= "..cld,player.x,player.y-28)
end




--player functions
---------------------------------------
function player_update()

   --physics
   player.dy+=gravity
   player.dx*=friction

   --particles
   spark(player.x,player.y,spark_width,spark_colors,spark_amount)

   --controls
   --left button
   if btn(⬅️) then
      player.dx-=player.acc
      player.running=true
      player.flp=true
      --particle
   end

   --right button
   if btn(➡️) then
      player.dx+=player.acc
      player.running=true
      player.flp=false
      --particle
   end

   --slide
   if player.running
   and not btn(⬅️)
   and not btn(➡️)
   and not player.falling
   and not player.jumping then
      player.running=false
      player.sliding=true
   end

   --jump
   if btn(❎)
   and player.landed then
   sfx(00)
      player.dy-=player.boost
      in_air=true
      player.landed=false
   end


   --release pollen
   if  btnp(🅾️) then
      if pollen==6 then
         for flwr_num, flwr in pairs(flower) do
            -- flwr collision

            if flwr.y+4>player.y-8
            and flwr.y+4<player.y+8
            and flwr.x+4>player.x-10
            and flwr.x+4<player.x+10 then
               flowergrow(flwr_num)
               pollen_release()

            end
         end
      end
   end

   --collisions
   --check collision up and down
   if player.dy>0 then
      player.falling=true
      player.landed=false
      player.jumping=false
      player.dy=limit_speed(player.dy,player.max_dy)

      --check down
      if collide_map(player,"down",0) then
         player.landed=true
         player.falling=false
         player.dy=0
         player.y-=((player.y+player.h+1)%8)-1

         ----debug----
         -- cld="yes"
         -- else cld="no"
      end
   elseif player.dy<0 then
      player.jumping=true
      --check up
      if collide_map(player,"up",1) then
         player.dy=0
         ----debug----
         --clu="yes"
         --else clu="no"
      end
   end

   --check collision left and right
   if player.dx<0 then
      player.dx=limit_speed(player.dx,player.max_dx)
      --check left collision
      if collide_map(player,"left",1) then
         player.dx=0
         ----debug----
         --cll="yes"
         --else
         --cll="no"
      end
   elseif player.dx>0 then
      player.dx=limit_speed(player.dx,player.max_dx)
      --check right collision
      if collide_map(player,"right",1) then
         player.dx=0
         ----test----
         --clr="yes"
         --else
         --clr="no"
      end
   end

   --stop sliding
   if player.sliding then
      dust(player.x,player.y,dust_width,dust_colors,dust_amount)
      if abs(player.dx)<.05
      or player.running then
         player.dx=0
         player.sliding=false
      end
   end

   --update player x, y
   player.x+=player.dx
   player.y+=player.dy
end

---------------------------------------
--animations
function player_ani()

   --jump
   if player.jumping then

      player.sp=6
      --falling
   elseif player.falling then
      player.sp=6
      --sliding
   elseif player.sliding then
      player.sp=8
      --running
   elseif player.running then
      if time()-player.anim>.1 then
         player.anim=time()
         player.sp+=1
         spark(player.x,player.y,spark_width,spark_colors,spark_amount)
         if player.sp>5 then
            player.sp=3
         end
      end
   else
      --player idle
      if time()-player.anim>.3 then
         player.anim=time()
         player.sp+=1
         spark(player.x,player.y,spark_width,spark_colors,spark_amount)
         if player.sp>2 then
            player.sp=1
         end
      end
   end
   --landed
   if player.dy==0 and in_air==true then
      player.sp=9
      sfx(01)
      dust(player.x,player.y,dust_width,dust_colors,dust_amount)
      offset=.06
      in_air=false
   end
   --limit to map
   if player.x<mapstart then
      player.x=mapstart
   end
   if player.x>mapend-player.w then
      player.x=mapend-player.w
   end

end


--utility functions

--limit speed
function limit_speed(num,maximum)
   return mid(-maximum,num,maximum)
end

---------------------------------------
--collision function
function collide_map(obj,aim,flag)
   --obj has to be a  table with:x,y,w,h
   --get obj info
   local x=obj.x local y=obj.y
   local w=obj.w local h=obj.h

   local x1=0 local y1=0
   local x2=0 local y1=0

   --movement collision
   --left
   if aim=="left" then
      x1=x-1 y1=y
      x2=x   y2=y+h-1

      --right
   elseif aim=="right" then
      x1=x+w   y1=y
      x2=x+w+1 y2=y+h-1

      --up
   elseif aim=="up" then
      x1=x+2   y1=y-1
      x2=x+w-3   y2=y

      --down
   elseif aim=="down" then
      x1=x+2   y1=y+h
      x2=x+w-3   y2=y+h
   end
   -----debug-----
   --x1r=x1
   --y1r=y1
   --x2r=x2
   --y2r=y2

   --pixels to tiles
   x1/=8
   y1/=8
   x2/=8
   y2/=8

   --check tile flags
   if fget(mget(x1,y1),flag)
   or fget(mget(x1,y2),flag)
   or fget(mget(x2,y1),flag)
   or fget(mget(x2,y2),flag)
   then
      return true
   else
      return false
   end
end

---------------------------------------
--screen shaking
function screen_shake()
   local shakesize = 8
   --shake parametres
   local fade = 0.9
   local offset_x=shakesize-rnd(shakesize*2)
   local offset_y=shakesize-rnd(shakesize*2)
   offset_x*=offset
   offset_y*=offset

   --set offset and fade out
   camera(camx+offset_x, offset_y)
   offset*=fade
   if (offset<0.05) offset=0
end

---------------------------------------
--sprite outline
function outline_sprite(n,col_outline,x,y,w,h,flip_x,flip_y)
   --sprite number, color, x,y,w,h,
   --flipped on x ture/false,
   --flipped on y true false
   --reset palette to col_outline
   for c=1,15 do
      pal(c,col_outline)
   end
   -- draw outline
   spr(n,x+1,y+yy,w,h,flip_x,flip_y)
   spr(n,x-1,y+yy,w,h,flip_x,flip_y)
   spr(n,x,y+1,w,h,flip_x,flip_y)
   spr(n,x,y-1,w,h,flip_x,flip_y)

   -- reset palette
   pal()
   -- draw final sprite
   spr(n,x,y,w,h,flip_x,flip_y)
end

---------------------------------------
--text outline
function outline_text(text,x,y,col1,col2)
   print(text,x-1,y,col2)
   print(text,x+1,y,col2)
   print(text,x,y-1,col2)
   print(text,x,y+1,col2)
   print(text,x,y,col1)
end

---------------------------------------
--ui
function draw_counter()
   outline_sprite(25,0,(camx+64)-20,0, 1,1,false,false)
   outline_sprite(25,0,(camx+64)-12,0, 1,1,false,false)
   outline_sprite(25,0,(camx+64)-4,0, 1,1,false,false)
   outline_sprite(25,0,(camx+64)+4,0, 1,1,false,false)
   outline_sprite(25,0,(camx+64)+12,0, 1,1,false,false)
   outline_sprite(25,0,(camx+64)+20,0, 1,1,false,false)

   if pollen>=1 then
      outline_sprite(41,0,(camx+64)-20,0, 1,1,false,false)
   end
   if pollen>=2 then
      outline_sprite(41,0,(camx+64)-12,0, 1,1,false,false)
   end
   if pollen>=3 then
      outline_sprite(41,0,(camx+64)-4,0, 1,1,false,false)
   end
   if pollen>=4 then
      outline_sprite(41,0,(camx+64)+4,0, 1,1,false,false)
   end
   if pollen>=5 then
      outline_sprite(41,0,(camx+64)+12,0, 1,1,false,false)
   end
   if pollen>=6 then
      outline_sprite(41,0,(camx+64)+20,0, 1,1,false,false)
   end

   spr(38,52+camx,10,1,1)
   spr(40,64+camx,10,1,1)
   spr(39,76+camx,10,1,1)

   if flower[1].age==5 then
      spr(22,52+camx,10,1,1)
   end
   if flower[2].age==5 then
      spr(24,64+camx,10,1,1)
   end
   if flower[3].age==5 then
      spr(23,76+camx,10,1,1)
   end
end

function playmusic()
if music_play==true then

		 if scene=="menu" then

   elseif scene=="game" then
    music(00)
   elseif scene=="pause" then

   elseif scene=="win" then

   end
  end
end



--environment

function starfall()
   --create the star obj
   for i=1, 50 do
      str={
         sprite=flr(rnd(str_cnt)
         +str_start),
         x=flr(rnd(1000)+5),
         y=i*(-str_drp),
         --test
         w=1,
         h=1
      }
      add(star,str)
   end
end

--draw each star
function stardraw()
   for str in all(star) do
      spr(str.sprite,str.x,str.y)
   end
end

---------------------------------------
--flowers & pollen
function pollen_count()
   pollen+=1
   sfx(31+pollen)
   if pollen>=6 then
      pollen=6
   end
end

function pollen_release()
   pollen=0
   sfx(38)
   explode(player.x,player.y,explode_size3,explode_colors2,explode_amount)
end

function spawn_plant()
   for i=1, 3 do
      flwr={
         sprite=plant[i],
         x=plantx[i]*8,
         y=13*8-9,
         w=1,
         h=1,
         age=1,
         idx=i,
         anim=0,
         sel=138
      }

      add(flower,flwr)
   end
end

function flowerdraw()
   for flwr in all(flower) do
      spark(flwr.x,flwr.y,spark_width2,spark_colors2,spark_amount2)
      if time()-flwr.anim>.1 then
         flwr.anim=time()
         flwr.sel+=1
         if flwr.sel>141 then
            flwr.sel=138
         end
      end
      spr(flwr.sel,flwr.x,flwr.y)
      outline_sprite(flwr.sprite,0,flwr.x,flwr.y,1,2,false,false)
   end
end

function flowergrow(flwr_num)
   if flower[flwr_num].age<5 then
      flower[flwr_num].sprite+=1
      flower[flwr_num].age+=1

   end
end

---------------------------------------
--map
function spawn_map()
   for i=0,8 do
      map( 16, 16, i*128+flr(camx-camx/8), 0, 17, 16)
   end

   for i=0,8 do
      palt(0, false)
      palt(15, true)
      map( 0, 16, i*128+(flr(camx-camx/4)), 0, 17, 16)
      palt()
   end

   for i=0, 8 do
      map( 32, 16, i*128+flr(camx-camx/2), 0, 17, 16)
   end

end

---------------------------------------
--draw turnips
function turnip_count()
   if time()-anim>.3 then
      anim=time()
      turnip1+=1
      turnip2+=1
      turnip3+=1
      turnip4+=1
      turnip5+=1
      turnip6+=1
      turnip7+=1
      turnip8+=1
      turnip9+=1

      if turnip1>55 then
         turnip1=54
      end
      if turnip2>57 then
         turnip2=56
      end
      if turnip3>45 then
         turnip3=44
      end
      if turnip4>43 then
         turnip4=42
      end
      if turnip5>14 then
         turnip5=13
      end
      if turnip6>35 then
         turnip6=34
      end
      if turnip7>33 then
         turnip7=32
      end
      if turnip8>37 then
         turnip8=36
      end
      if turnip9>161 then
         turnip9=160
      end
   end
end

function turnip_draw1()
   if flower[1].age >= 2 then
      outline_sprite(turnip1,0,flower[1].x-10,flower[1].y+1,1,1)
      outline_sprite(62,0,flower[1].x-10,flower[1].y+10,1,1)
   end
   if flower[1].age >= 3 then
      outline_sprite(turnip2,0,flower[1].x+10,flower[1].y+1,1,1)
      outline_sprite(46,0,flower[1].x+10,flower[1].y+10,1,1)
   end
   if flower[1].age >= 4 then
      outline_sprite(turnip4,0,flower[1].x-24,flower[1].y-3,1,2)
      outline_sprite(47,0,flower[1].x-24,flower[1].y+14,1,1)
   end
   if flower[1].age >= 5 then
      outline_sprite(turnip3,0,flower[1].x+24,flower[1].y-3,1,2)
      outline_sprite(63,0,flower[1].x+24,flower[1].y+14,1,1)
   end


end

function turnip_draw2()

   if flower[2].age >= 2 then
      outline_sprite(turnip6,0,flower[2].x-10,flower[2].y+1,1,1)
      outline_sprite(62,0,flower[2].x-10,flower[2].y+10,1,1)
   end
   if flower[2].age >= 3 then
      outline_sprite(turnip7,0,flower[2].x+10,flower[2].y+1,1,1)
      outline_sprite(46,0,flower[2].x+10,flower[2].y+10,1,1)
   end
   if flower[2].age >= 4 then
      outline_sprite(turnip5,0,flower[2].x-24,flower[2].y-3,1,2)
      outline_sprite(47,0,flower[2].x-24,flower[2].y+14,1,1)
   end
   if flower[2].age >= 5 then
      outline_sprite(turnip3,0,flower[2].x+24,flower[2].y-3,1,2)
      outline_sprite(63,0,flower[2].x+24,flower[2].y+14,1,1)
   end


end

function turnip_draw3()

   if flower[3].age >= 2 then
      outline_sprite(turnip9,0,flower[3].x-10,flower[3].y+1,1,1)
      outline_sprite(62,0,flower[3].x-10,flower[3].y+10,1,1)
   end
   if flower[3].age >= 3 then
      outline_sprite(turnip8,0,flower[3].x+10,flower[3].y+1,1,1)
      outline_sprite(46,0,flower[3].x+10,flower[3].y+10,1,1)
   end
   if flower[3].age >= 4 then
      outline_sprite(turnip4,0,flower[3].x-24,flower[3].y-3,1,2)
      outline_sprite(47,0,flower[3].x-24,flower[3].y+14,1,1)
   end
   if flower[3].age >= 5 then
      outline_sprite(turnip5,0,flower[3].x+24,flower[3].y-3,1,2)
      outline_sprite(63,0,flower[3].x+24,flower[3].y+14,1,1)
   end


end


--particle functions

function add_fx(x,y,die,dx,dy,antigrav,grav,grow,shrink,r,c_table)
   local fx={
      x=x,
      y=y,
      t=0,
      die=die,
      dx=dx,
      dy=dy,
      antigrav=antigrav,
      grav=grav,
      grow=grow,
      shrink=shrink,
      r=r,
      c=0,
      c_table=c_table
   }
   add(effects,fx)
end

function update_fx()
   for fx in all(effects) do
      --lifetime
      fx.t+=1
      if fx.t>fx.die then del(effects,fx) end

      --color depends on lifetime
      if fx.t/fx.die < 2/#fx.c_table then
         fx.c=fx.c_table[1]

      elseif fx.t/fx.die < 3/#fx.c_table then
         fx.c=fx.c_table[2]

      elseif fx.t/fx.die < 4/#fx.c_table then
         fx.c=fx.c_table[3]

      else
         fx.c=fx.c_table[4]
      end

      --physics
      if fx.antigrav then fx.dy-=.05 end
      if fx.grav then fx.dy +=.05 end
      if fx.grow then fx.r+=.1 end
      if fx.shrink then fx.r-=.2 end

      --move
      fx.x+=fx.dx
      fx.y+=fx.dy
   end
end

function draw_fx()
   for fx in all(effects) do
      --draw pixel for size 1, draw circle for larger
      if fx.r<=1 then
         pset(fx.x,fx.y,fx.c)
      else
         circfill(fx.x,fx.y,fx.r,fx.c)
      end
   end
end


----- particle effects
---------------------------------------
-- motion firefly effect
function firefly(x,y,w,c_table,num)

   for i=0, num do
      --settings
      add_fx(
      x+rnd(w)-w/2,  -- x
      y+rnd(w)-w/2,  -- y
      8 +rnd(10),  -- die
      0,         -- dx
      0,         -- dy
      true,     -- antigravity
      false,     -- gravity
      false,     -- grow
      false,     -- shrink
      1,         -- radius
      c_table    -- color_table
      )
   end
end
---------------------------------------
-- explosion effect
function explode(x,y,r,c_table,num)

   for i=0, num do

      --settings
      add_fx(
      x,         -- x
      y,         -- y
      50+rnd(25),-- die
      rnd(2)-1,  -- dx
      rnd(2)-1,  -- dy
      false,     -- antigravity
      false,     -- gravity
      false,     -- grow
      true,      -- shrink
      r,         -- radius
      c_table    -- color_table
      )
   end
end
---------------------------------------
-- dust effect
function dust(x,y,w,c_table,num)



   for i=0, num do
      spawn+=1
      if spawn>=1 then
         --settings
         add_fx(
         x+rnd(w)-w/2,-- x
         y+8+rnd(2),  -- y
         4+rnd(3),    -- die
         rnd(2),      -- dx
         -.5,          -- dy
         true,        -- antigravity
         false,       -- gravity
         true,        -- grow
         false,       -- shrink
         flr(rnd(2)), -- radius
         c_table      -- color_table
         )
         spawn = 0
      end
   end
end
---------------------------------------
-- spark effect
function spark(x,y,w,c_table,num)

   for i=0, num do
      spawn+=.05
      if spawn>=1 then
         --settings
         add_fx(
         x+4+rnd(w)-w/2,  -- x
         y+3+rnd(2),  -- y
         7+rnd(4),-- die
         rnd(2)-1,         -- dx
         rnd(2)-1,       -- dy
         true,     -- antigravity
         false,     -- gravity
         false,     -- grow
         true,      -- shrink
         flr(rnd(4)), -- radius
         c_table    -- color_table
         )
         spawn = 0
      end
   end
end

