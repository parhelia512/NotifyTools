function JY_Main()--���������
os.remove("debug.txt")--�����ǰ��debug���
xpcall(JY_Main_sub,myErrFun)--������ô���
end

function JY_Main_sub()--��������Ϸ���������
dofile(CONFIG.ScriptPath .. "jyconfig.lua") --������Ϸ�����ļ�
dofile(CONFIG.ScriptPath .. "kdef.lua") --������Ϸ�¼�
SetGlobalConst()
SetGlobal()
--��ֹ����ȫ�̱���
setmetatable(_G,{ __newindex=function (_,n)
error("attempt read write to undeclared variable " .. n,2)
end,
__index=function (_,n)
error("attempt read read to undeclared variable " .. n,2)
end,
} )
lib.Debug("JY_Main start.")
math.randomseed(tostring(os.time()):reverse():sub(1, 6))--��ʼ�������������
lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval)--���ü����ظ���
lib.GetKey()
YJZMain()
end

--����ҷ����в��ӵ�ƽ���ȼ�
function pjlv()
local lv_t={}
local cz=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==1 then
table.insert(lv_t,JY.Person[i]["�ȼ�"])
cz=cz+1
end
end
table.sort(lv_t,function(a,b)return b<a end)
for ii=1,cz do
table.insert(lv_t,1)
end
local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end
lv=math.modf(lv/cz)--�õ��ҷ����в��ӵ�ƽ���ȼ�
return lv
end

function myErrFun(err)--��������ӡ������Ϣ
lib.Debug(err)--���������Ϣ
lib.Debug(debug.traceback())--������ö�ջ��Ϣ
end

function SetGlobal()--������Ϸ�ڲ�ʹ�õ�ȫ�̱���
JY={}
JY.Status=GAME_START--��Ϸ��ǰ״̬
--����R������
JY.Base={}--��������
JY.PersonNum=0--�������
JY.Person={}--��������
JY.BingzhongNum=0--�������
JY.Bingzhong={}--��������
JY.SceneNum=0--��������
JY.Scene={}--��������
JY.ItemNum=0--���߸���
JY.Item={}--��������
JY.MagicNum=0--���Ը���
JY.Magic={}--��������
JY.SkillNum=0--�ؼ�����
JY.Skill={}--�ؼ�����
JY.SubScene=-1--��ǰ�ӳ������
JY.SubSceneX=0--�ӳ�����ʾλ��ƫ�ƣ������ƶ�ָ��ʹ��
JY.SubSceneY=0
JY.Darkness=0--=0 ��Ļ������ʾ��=1 ����ʾ����Ļȫ��
JY.MmapMusic=-1--�л����ͼ���֣���������ͼʱ��������ã��򲥷Ŵ�����
JY.CurrentBGM=-1--��ǰ���ŵ�����id�������ڹر�����ʱ��������id��
JY.EnableMusic=1--�Ƿ񲥷����� 1 ���ţ�0 ������
JY.EnableSound=1--�Ƿ񲥷���Ч 1 ���ţ�0 ������
JY.LLK_N=0
JY.Dark=true
JY.Smap={}
JY.Tid=0--SMAPʱ����ǰѡ������� �� ����˵��������
JY.EventID=1
JY.LoadedPic=0
JY.MenuPic={
num=0,
pic={},
x={},
y={},
}
JY.Death=0--����ս���¼�-"������XXʱ����"
JY.ReFreshTime=0
War={}
War.Person={}
TeamSelect={}--���ڴ���ս��ǰ����ѡ��
end

function CleanMemory()--����lua�ڴ�
if CONFIG.CleanMemory==1 then
collectgarbage("collect")
end
end

--�������ؿ�����
function Game_Cycle()
for i=JY.Base["�¼�333"]+1,9999,1 do
PlayBGM(math.random(19))
local llk=lianliankan(i+9)

if llk then
if i>JY.Base["�¼�333"] and i<=30 then
JY.Base["�¼�333"]=i
end
else
return
end
end
end

--��������Ϸ
function lianliankan(level)
local B={}
local num
local headbox={}
local X_Num,Y_Num
local pic_w,pic_h
local x_off,y_off
local limit,start_time,now_time
local mid_point={
x={},
y={},
}
local select_a={
x=0,
y=0,
}
local select_b={
x=0,
y=0,
}
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,0,0,0)
lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],0)
pic_w,pic_h=lib.PicGetXY(0,0*2)
X_Num=math.modf(CC.ScreenW/pic_w)
Y_Num=math.modf(CC.ScreenH*15/16/pic_h)
if X_Num~=math.modf(X_Num/2)*2 and Y_Num~=math.modf(Y_Num/2)*2 then
if CC.ScreenW-pic_w*X_Num<CC.ScreenH*15/16-pic_h*Y_Num then
X_Num=X_Num-1
else
Y_Num=Y_Num-1
end
end
if X_Num<6 or Y_Num<4 then
WarDrawStrBoxConfirm("��Ļ�ֱ������ù�С��",M_White,true)
return false
end
num=X_Num*Y_Num/2
limit=X_Num*Y_Num*(10+level)*100+5000
local function sample(st,rp)
--���������rp �Ƿ�Ż�
local n=#st
local r=-1
if n>1 then
n=math.random(n)
end
r=st[n]
if not rp then
table.remove(st,n)
end
return r
end
local t_head={}
for i=1,228 do
--ͼƬ��
table.insert(t_head,i)
end
for i=1,math.min(level,50) do
headbox[i]=sample(t_head)--��������ʹ�õ�ͷ��
end
t_head={}
for i=1,Y_Num*X_Num/2 do
local picid=sample(headbox,true)
table.insert(t_head,picid)
table.insert(t_head,picid)
end
X_Num=X_Num+2
Y_Num=Y_Num+2
for i=1,Y_Num do
B[i]={}
for j=1,X_Num do
if between(i,2,Y_Num-1) and between(j,2,X_Num-1) then
B[i][j]=sample(t_head)
else
B[i][j]=-1
end
end
end
x_off=math.modf((CC.ScreenW-pic_w*X_Num)/2)
y_off=math.modf(CC.ScreenH/16+(CC.ScreenH*15/16-pic_h*Y_Num)/2)
local function SHOW()
for y=1,Y_Num do
for x=1,X_Num do
if B[y][x]>-1 then
lib.PicLoadCache(0,B[y][x]*2,pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,1)
end
end
end
if select_a.x~=0 and select_a.y~=0 then
DrawBox(pic_w*(select_a.x-1)+x_off,pic_h*(select_a.y-1)+y_off,pic_w*select_a.x+x_off,pic_h*select_a.y+y_off,M_White)
end
if select_b.x~=0 and select_b.y~=0 then
DrawBox(pic_w*(select_b.x-1)+x_off,pic_h*(select_b.y-1)+y_off,pic_w*select_b.x+x_off,pic_h*select_b.y+y_off,M_White)
end
end
local function DrawTime()
now_time=lib.GetTime()
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH/16,RGB(192,192,192))
DrawString(0,0,string.format("Level:%d",level-9),M_Black,16)
DrawBox(160,3,CC.ScreenW-4,CC.ScreenH/16-5,M_White)
DrawBox(160,3,160+(CC.ScreenW-164)*(start_time+limit-now_time)/limit,CC.ScreenH/16-5,M_White)
end
local function Delay(t)
for i=1,t,10 do
DrawTime()
lib.ShowSurface(0)
lib.Delay(10)
end
end
local function FIND()
local len_min=(X_Num+Y_Num)*2
for x=1,X_Num do
local flag=true
local step
if select_b.y>select_a.y then
step=1
elseif select_b.y==select_a.y then
step=0
else
step=-1
end
if step~=0 then
for y=select_a.y+step,select_b.y-step,step do
if B[y][x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_a.x>x then
step=1
elseif select_a.x==x then
step=0
else
step=-1
end
if step~=0 and x~=select_a.x then
for xx=x,select_a.x-step,step do
if B[select_a.y][xx]~=-1 then
flag=false
break
end
end
end
if flag then
if select_b.x>x then
step=1
elseif select_b.x==x then
step=0
else
step=-1
end
if step~=0 and x~=select_b.x then
for xx=x,select_b.x-step,step do
if B[select_b.y][xx]~=-1 then
flag=false
break
end
end
end
if flag then
local len=math.abs(x-select_a.x)+math.abs(x-select_b.x)+math.abs(select_a.y-select_a.y)
if len<len_min then
len_min=len
mid_point.x[1]=select_a.x
mid_point.y[1]=select_a.y
mid_point.x[2]=x
mid_point.y[2]=select_a.y
mid_point.x[3]=x
mid_point.y[3]=select_b.y
mid_point.x[4]=select_b.x
mid_point.y[4]=select_b.y
end
end
end
end
end
for y=1,Y_Num do
local flag=true
local step
if select_b.x>select_a.x then
step=1
elseif select_b.x==select_a.x then
step=0
else
step=-1
end
if step~=0 then
for x=select_a.x+step,select_b.x-step,step do
if B[y][x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_a.y>y then
step=1
elseif select_a.y==y then
step=0
else
step=-1
end
if step~=0 and y~=select_a.y then
for yy=y,select_a.y-step,step do
if B[yy][select_a.x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_b.y>y then
step=1
elseif select_b.y==y then
step=0
else
step=-1
end
if step~=0 and y~=select_b.y then
for yy=y,select_b.y-step,step do
if B[yy][select_b.x]~=-1 then
flag=false
break
end
end
end
if flag then
local len=math.abs(y-select_a.y)+math.abs(y-select_b.y)+math.abs(select_a.x-select_a.x)
if len<len_min then
len_min=len
mid_point.x[1]=select_a.x
mid_point.y[1]=select_a.y
mid_point.x[2]=select_a.x
mid_point.y[2]=y
mid_point.x[3]=select_b.x
mid_point.y[3]=y
mid_point.x[4]=select_b.x
mid_point.y[4]=select_b.y
end
end
end
end
end
if len_min<(X_Num+Y_Num)*2 then
return true
else
return false
end
end
lib.FillColor(0,0,0,0,0)
start_time=lib.GetTime()
now_time=start_time
SHOW()
lib.ShowSurface(0)
lib.Delay(20)
while num>0 do
if (now_time-start_time)>limit then
WarDrawStrBoxConfirm("ʧ�ܣ���Ϸ����������",M_White,true)
PicCatchIni()
return false
end
local eventtype,keypress,x,y=lib.GetKey(1)
if eventtype==3 and keypress==3 then
PlayWavE(1)
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
PicCatchIni()
return false
end
end
if eventtype==3 then
local X=1+math.modf((x-x_off)/pic_w)
local Y=1+math.modf((y-y_off)/pic_h)
if x-x_off>=0 and y-y_off>=0 and X>=1 and X<=X_Num and Y>=1 and Y<=Y_Num and B[Y][X]~=-1 then
if (select_a.x==0 or select_a.y==0) then
select_a.x=X
select_a.y=Y
PlayWavE(0)
elseif select_a.x==X and select_a.y==Y then
select_a.x=0
select_a.x=0
PlayWavE(1)
else
if (select_b.x==0 or select_b.y==0) then
select_b.x=X
select_b.y=Y
PlayWavE(0)
elseif select_b.x==X and select_b.y==Y then
select_b.x=0
select_b.x=0
PlayWavE(1)
else
WarDrawStrBoxConfirm("�����쳣����Ϸ����������",M_White,true)
PicCatchIni()
return false
end
end
end
if select_a.x~=0 and select_a.y~=0 and select_b.x~=0 and select_b.y~=0 then
lib.FillColor(0,0,0,0,0)
SHOW()
Delay(50)
if B[select_a.y][select_a.x]==B[select_b.y][select_b.x] and FIND(1,select_a.x,select_a.y,-1) then
B[select_a.y][select_a.x]=-1
B[select_b.y][select_b.x]=-1
num=num-1
for t=1,3 do
if mid_point.x[t]~=mid_point.x[t+1] or mid_point.y[t]~=mid_point.y[t+1] then
DrawBox(pic_w*mid_point.x[t]+x_off-pic_w/2,pic_h*mid_point.y[t]+y_off-pic_h/2,
pic_w*mid_point.x[t+1]+x_off-pic_w/2,pic_h*mid_point.y[t+1]+y_off-pic_h/2,M_White)
end
end
PlayWavE(11)
Delay(250)
else
PlayWavE(3)
Delay(400)
end
select_a.x=0
select_a.y=0
select_b.x=0
select_b.y=0
end
lib.FillColor(0,0,0,0,0)
SHOW()
Delay(10)
end
Delay(10)
end
WarDrawStrBoxConfirm(string.format("��ϲ�������%d��",level-8),M_White,true)
GetMoney(100)--ÿ��һ�� ���100��
lib.ShowSurface(0)
lib.Delay(500)
return true
end

--����һ���������İ�ɫ�����Ľǰ���
function DrawBox(x1,y1,x2,y2,color)--����һ���������İ�ɫ����
local s=4
lib.Background(x1+4,y1,x2-4,y1+s,128)
lib.Background(x1+1,y1+1,x1+s,y1+s,128)
lib.Background(x2-s,y1+1,x2-1,y1+s,128)
lib.Background(x1,y1+4,x2,y2-4,128)
lib.Background(x1+1,y2-s,x1+s,y2-1,128)
lib.Background(x2-s,y2-s+1,x2-1,y2,128)
lib.Background(x1+4,y2-s,x2-4,y2,128)
local r,g,b=GetRGB(color)
local color2=RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2))
DrawBox_1(x1-1,y1-1,x2-1,y2-1,color2)
DrawBox_1(x1+1,y1-1,x2+1,y2-1,color2)
DrawBox_1(x1-1,y1+1,x2-1,y2+1,color2)
DrawBox_1(x1+1,y1+1,x2+1,y2+1,color2)
DrawBox_1(x1,y1,x2,y2,color)
end

--�����Ľǰ����ķ���
function DrawBox_1(x1,y1,x2,y2,color)--�����Ľǰ����ķ���
local s=4
lib.DrawRect(x1+s,y1,x2-s,y1,color)
lib.DrawRect(x1+s,y2,x2-s,y2,color)
lib.DrawRect(x1,y1+s,x1,y2-s,color)
lib.DrawRect(x2,y1+s,x2,y2-s,color)
lib.DrawRect(x1+2,y1+1,x1+s-1,y1+1,color)
lib.DrawRect(x1+1,y1+2,x1+1,y1+s-1,color)
lib.DrawRect(x2-s+1,y1+1,x2-2,y1+1,color)
lib.DrawRect(x2-1,y1+2,x2-1,y1+s-1,color)
lib.DrawRect(x1+2,y2-1,x1+s-1,y2-1,color)
lib.DrawRect(x1+1,y2-s+1,x1+1,y2-2,color)
lib.DrawRect(x2-s+1,y2-1,x2-2,y2-1,color)
lib.DrawRect(x2-1,y2-s+1,x2-1,y2-2,color)
end

--����һ���������İ�ɫ�����Ľǰ���
function DrawBox(x1,y1,x2,y2,color,bjcolor)--����һ���������İ�ɫ����
local s=4
bjcolor=bjcolor or 0
if bjcolor>=0 then
lib.Background(x1,y1+s,x1+s,y2-s,128,bjcolor)--��Ӱ���Ľǿճ�
lib.Background(x1+s,y1,x2-s,y2,128,bjcolor)
lib.Background(x2-s,y1+s,x2,y2-s,128,bjcolor)
end
if color>=0 then
local r,g,b=GetRGB(color)
DrawBox_1(x1+1,y1,x2,y2,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)))
DrawBox_1(x1,y1,x2-1,y2-1,color)
end
end

--�޸ĺ��drawbox���߿�Ӵ�
function DrawGameBox(x1,y1,x2,y2)
lib.PicLoadCache(4,260*2,x1,y1,1)
end

function WarFillColor(x1,y1,x2,y2,clarity,color,size)
color=color or M_Red
clarity=clarity or 128
size=size or 8
local flag1=true
fory=y1,y2-1,size do
local flag2=flag1
forx=x1,x2-1,size do
if flag2 then
lib.Background(x,y,x+size,y+size,clarity,color)
end
flag2=not flag2
end
flag1=not flag1
end
end

--��ʾ��Ӱ�ַ���
function DrawString(x,y,str,color,size)--��ʾ��Ӱ�ַ���
if CC.FontType==0 then
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
elseif CC.FontType==1 then
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
end

function DrawString2(x,y,str,color,size)--��ʾ��Ӱ�ַ���
lib.DrawStr(x-2,y,str,M_Black,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
lib.DrawStr(x+1,y,str,M_Black,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
DrawString(x,y,str,color,size)
end

--��ʾ������ַ���
--(x,y) ���꣬�����Ϊ-1,������Ļ�м���ʾ
function DrawStrBox(x,y,str,color,size)--��ʾ������ַ���
local ll=#str
local w=size*ll/2+2*CC.MenuBorderPixel
local h=size+2*CC.MenuBorderPixel
if x==-1 then
x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2
end
DrawBox(x,y,x+w-1,y+h-1,M_White)
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size)
end

function DrawStrBox(x,y,str,color,size,bjcolor)--��ʾ������ַ���
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num
if x==-1 then
x=(CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size*num-2*CC.MenuBorderPixel)/2
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
DrawBox(x,y,x+w-1,y+h-1,M_White,bjcolor)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+size*(i-1),strarray[i],color,size)
end
end

function DrawStr(x,y,str,color,size)--��ʾ�ַ���,�����
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
for i=1,num do
DrawString(x,y+size*(i-1),strarray[i],color,size)
end
end

--�ָ��ַ���
function Split(szFullString,szSeparator)
local nFindStartIndex=1
local nSplitIndex=1
local nSplitArray={}
while true do
local nFindLastIndex=string.find(szFullString, szSeparator, nFindStartIndex)
if not nFindLastIndex then
nSplitArray[nSplitIndex]=string.sub(szFullString, nFindStartIndex, string.len(szFullString))
break
end
nSplitArray[nSplitIndex]=string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
nFindStartIndex=nFindLastIndex + string.len(szSeparator)
nSplitIndex=nSplitIndex + 1
end
return nSplitIndex,nSplitArray
end

--��ʾ��ѯ��Y/N��������Y���򷵻�true, N�򷵻�false
--(x,y) ���꣬�����Ϊ-1,������Ļ�м���ʾ
--��Ϊ�ò˵�ѯ���Ƿ�
function DrawStrBoxYesNo(x,y,str,color,size)--��ʾ�ַ�����ѯ��Y/N
lib.GetKey()
local ll=#str
local w=size*ll/2+2*CC.MenuBorderPixel
local h=size+2*CC.MenuBorderPixel
if x==-1 then
x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2
end
DrawStrBox(x,y,str,color,size)
local menu={{"ȷ��/��",nil,1},
{"ȡ��/��",nil,2}}
local r=ShowMenu(menu,2,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,size*0.8,M_Orange, M_White)
if r==1 then
return true
else
return false
end
end

function WarShowTarget(firstShow)--��ʾ����Ŀ��
-- notWar true notwar, false in war
lib.GetKey()
local x,y
local w,h=320,192
local size=16
x=16+576/2
y=32+432/2
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+148
local y2=y1+24
local str=""
local T={[0]="��","��","��","��","��","��","��","��","��","��",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"����","����","����","����","����","����","����","����","����","����",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������","������","������","������","������","������","������","������","������","������",
"������",}
if firstShow then
PlayWavE(0)
str="���ƻ���"..T[War.MaxTurn]
else
str="���ڻ�����"..T[War.Turn].."��"..T[War.MaxTurn]
end
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
lib.PicLoadCache(4,81*2,x,y,1)
DrawString(x+16,y+16,War.WarName,M_White,size)
DrawString(x+240,y+16,"ʤ������",M_White,size)
DrawStr(x+32,y+56,War.WarTarget,M_White,size)
DrawStr(x+24,y+152,str,M_White,size)
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
WarDelay(4)
return
else
current=0
end
end
end

function DrawItemStatus(id,pid)--��ʾ��Ʒ����
local str=JY.Item[id]["˵��"]
if CC.Enhancement then
if id==JY.Person[pid]["����"] and JY.Person[pid]["����"]==JY.Item[id]["ר���ؼ���"] then
str=str.."*��Ч��"..JY.Skill[JY.Item[id]["ר���ؼ�"]]["˵��"]
elseif id==JY.Person[pid]["����"] and JY.Item[id]["�ؼ�"]>0 then
str=str.."*��Ч��"..JY.Skill[JY.Item[id]["�ؼ�"]]["˵��"]
end
end
DrawStrStatus(JY.Item[id]["����"],str)
end

function DrawSkillStatus(id)--��ʾ��������
 DrawStrStatus(JY.Skill[id]["����"],JY.Skill[id]["˵��"])
end

function DrawBingZhongStatus(id)--��ʾ��������
 DrawStrStatus(JY.Bingzhong[id]["����"],JY.Bingzhong[id]["˵��"])
end

function DrawLieZhuan(name)--��ʾ�д�
 DrawStrStatus("����Ӣ���д� - "..name,CC.LieZhuan[name])
end

function DrawStrStatus(str1,str2)--��ʾ����
lib.GetKey()
local x,y
local w,h=320,128
local size=16
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
notWar=false
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
notWar=true
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
notWar=true
end
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+92
local y2=y1+24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
lib.PicLoadCache(4,80*2,x,y,1)
DrawString(x+16,y+10,str1,C_Name,size)--oldy=16
DrawStr(x+16,y+28,GenTalkString(str2,18),M_White,size)--oldy=36
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh()
end
end
local current=0
PlayWavE(0)
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return
else
current=0
end
end
end

function WarDrawStrBoxConfirm(str,color,notWar)--��ʾ�ַ�����ѯ��Y/N
lib.GetKey()
local x,y
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=str.."* "
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
end
local x4=x+w/2
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=y+h/2
local y1=y2-24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
if notWar then
DrawYJZBox(-1,-1,str,color,notWar)
else
DrawYJZBox(-1,-1,str,color)
end
if flag==2 then
lib.PicLoadCache(4,56*2,x3,y1,1)
else
lib.PicLoadCache(4,55*2,x3,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh()
end
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
 current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return false
else
current=0
end
end
end

function WarDrawStrBoxYesNo(str,color,notWar)--��ʾ�ַ�����ѯ��Y/N
lib.GetKey()
local x,y
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=str.."* "
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576)/2
y=32+(432)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640)/2
y=16+(400)/2
else
x=(CC.ScreenW)/2
y=(CC.ScreenH)/2
end
local x4=x+w/2
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=y+h/2
local y1=y2-24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
if notWar then
DrawYJZBox(-1,-1,str,color,notWar)
else
DrawYJZBox(-1,-1,str,color)
end
if flag==1 then
lib.PicLoadCache(4,52*2,x1,y1,1)
else
lib.PicLoadCache(4,51*2,x1,y1,1)
end
if flag==2 then
lib.PicLoadCache(4,54*2,x3,y1,1)
else
lib.PicLoadCache(4,53*2,x3,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh()
end
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return true
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return false
else
current=0
end
end
end

function DrawStrBoxWaitKey(s,color)--��ʾ�ַ������ȴ�����
lib.GetKey()
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
DrawYJZBox(-1,-1,s,color,true)
ShowScreen()
 WaitKey()
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
ShowScreen()
end

function WarDrawStrBoxWaitKey(s,color,x,y)--��ʾ�ַ������ȴ����� ������ս�������汣��ˢ��
x=x or -1
y=y or -1
lib.GetKey()
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox(x,y,s,color)
local eventtype,keypress,x,y=lib.GetMouse(1)
ReFresh()
if eventtype==1 or eventtype==3 then
break
end
end
end

function WarDrawStrBoxDelay(s,color,x,y,n)--��ʾ�ַ������ȴ����� ������ս�������汣��ˢ��
x=x or -1
y=y or -1
n=n or 36
lib.GetKey()
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox(x,y,s,color)
local eventtype,keypress,x,y=lib.GetMouse(1)
ReFresh()
if eventtype==1 or eventtype==3 then
break
end
end
end

function DrawYJZBox(x,y,str,color,notWar)--��ʾ������ַ���
notWar=notWar or false
local size=16
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if x==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y=16+(400-h)/2
else
y=(CC.ScreenH-h)/2
end
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+7,boxy+7,boxx+boxw-7,boxy+boxh-7)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size)
end
end

function DrawYJZBox_sub(x,y,w,h)
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
end

function WarDrawStrBoxDelay2(s,color,x,y,n)--��ʾ�ַ������ȴ����� ������ս�������汣��ˢ��
x=x or -1
y=y or -1
n=n or 16
lib.GetKey()
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(x,y,s,color)
lib.GetKey()
ReFresh()
end
end

function DrawYJZBox2(x,y,str,color)--��ʾ������ַ���
local size=16
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
 
if x==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y=16+(400-h)/2
else
y=(CC.ScreenH-h)/2
end
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,60*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,60*2,boxx,boxy+boxh-110,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy+boxh-110,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+7,boxy+7,boxx+boxw-7,boxy+boxh-7)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size)
end
end

function ShowScreen()--���������תΪ����
if JY.Dark then
Light()
else
lib.ShowSurface(0)
end
end

function RGB(r,g,b)--������ɫRGB
return r*65536+g*256+b
end

function GetRGB(color)--������ɫ��RGB����
color=color%(65536*256)
local r=math.floor(color/65536)
color=color%65536
local g=math.floor(color/256)
local b=color%256
return r,g,b
end

--�ȴ���������
function WaitKey(flag)--�ȴ���������
local keyPress=-1
while true do
local eventtype,keypress,x,y=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
MOUSE.status='IDLE'
break
end
lib.Delay(20)
end
lib.Delay(100)
return keyPress
end

function LoadRecord(id)-- ��ȡ��Ϸ����
Dark()
local t1=lib.GetTime()
local data=Byte.create(4*8)
--��ȡsavedata
Byte.loadfile(data,CC.SavedataFile,0,4*8)
CC.font=Byte.get16(data,0)
CC.MusicVolume=Byte.get16(data,2)
CC.SoundVolume=Byte.get16(data,4)
CC.zdby=Byte.get16(data,6)
CC.cldh=Byte.get16(data,8)
CC.MoveSpeed=Byte.get16(data,10)
Config()
PicCatchIni()
--��ȡR*.idx�ļ�
Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8)
local idx={}
idx[0]=100
for i=1,8 do
idx[i]=Byte.get32(data,4*(i-1))
end
--��ȡR*.grp�ļ�
JY.Data_Base=Byte.create(idx[1]-idx[0])--��������
Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0])
--���÷��ʻ������ݵķ����������Ϳ����÷��ʱ�ķ�ʽ�����ˣ������ðѶ���������ת��Ϊ����Լ����ʱ��Ϳռ�
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v)
end
}
setmetatable(JY.Base,meta_t)
if JY.Base["��Ϸģʽ"]==1 then
CC.Enhancement=true
else
CC.Enhancement=false
end
if CC.Enhancement==false then
CC.Person_S["����"]={48,0,2,false}
CC.Person_S["����"]={50,0,2,false}
CC.Person_S["ͳ��"]={52,0,2,false}
CC.Person_S["��������"]={54,0,2,false}
CC.Person_S["��������"]={56,0,2,false}
CC.Person_S["ͳ�ʾ���"]={58,0,2,false}
else
CC.Person_S["����"]={48,0,2,true}
CC.Person_S["����"]={50,0,2,true}
CC.Person_S["ͳ��"]={52,0,2,true}
CC.Person_S["��������"]={54,0,2,true}
CC.Person_S["��������"]={56,0,2,true}
CC.Person_S["ͳ�ʾ���"]={58,0,2,true}
end
JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize)--���� /newgamesave��ʵ�ʴ浵 ��϶�ȡ
JY.Data_Person_Base=Byte.create(CC.PersonSize*JY.PersonNum)
JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum)
Byte.loadfile(JY.Data_Person_Base, CC.R_GRPFilename[0],idx[1],CC.PersonSize*JY.PersonNum)
Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
for i=0,JY.PersonNum-1 do
JY.Person[i]={}
if i<421 then
local meta_t={
__index=function(t,k)
return GetPersonData(i*CC.PersonSize,CC.Person_S,k)--421��ǰ�������϶�ȡ��421�Ժ�Ϊ���佫
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v)
end
}
setmetatable(JY.Person[i],meta_t)
else
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v)
end
}
setmetatable(JY.Person[i],meta_t)
end
end
JY.BingzhongNum=math.floor((idx[3]-idx[2])/CC.BingzhongSize)--���� /��ȡnewgamesave
JY.Data_Bingzhong=Byte.create(CC.BingzhongSize*JY.BingzhongNum)
Byte.loadfile(JY.Data_Bingzhong,CC.R_GRPFilename[0],idx[2],CC.BingzhongSize*JY.BingzhongNum)
for i=0,JY.BingzhongNum-1 do
JY.Bingzhong[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k,v)
end
}
setmetatable(JY.Bingzhong[i],meta_t)
end
JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize)--����
JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum)
Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum)
for i=0,JY.SceneNum-1 do
JY.Scene[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v)
end
}
setmetatable(JY.Scene[i],meta_t)
end
JY.ItemNum=math.floor((idx[5]-idx[4])/CC.ItemSize)--���� /��ȡnewgamesave
JY.Data_Item=Byte.create(CC.ItemSize*JY.ItemNum)
Byte.loadfile(JY.Data_Item,CC.R_GRPFilename[0],idx[4],CC.ItemSize*JY.ItemNum)
for i=0,JY.ItemNum-1 do
JY.Item[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k,v)
end
}
setmetatable(JY.Item[i],meta_t)
end
JY.MagicNum=math.floor((idx[6]-idx[5])/CC.MagicSize)--���� /��ȡnewgamesave
JY.Data_Magic=Byte.create(CC.MagicSize*JY.MagicNum)
Byte.loadfile(JY.Data_Magic,CC.R_GRPFilename[0],idx[5],CC.MagicSize*JY.MagicNum)
for i=0,JY.MagicNum-1 do
JY.Magic[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k,v)
end
}
setmetatable(JY.Magic[i],meta_t)
end
JY.SkillNum=math.floor((idx[7]-idx[6])/CC.SkillSize)--�ؼ� /��ȡnewgamesave
JY.Data_Skill=Byte.create(CC.SkillSize*JY.SkillNum)
Byte.loadfile(JY.Data_Skill,CC.R_GRPFilename[0],idx[6],CC.SkillSize*JY.SkillNum)
for i=0,JY.SkillNum-1 do
JY.Skill[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k,v)
end
}
setmetatable(JY.Skill[i],meta_t)
end
collectgarbage()
lib.Debug(string.format("Loadrecord%d time=%d",id,lib.GetTime()-t1))
JY.Smap={}
for i=1,JY.SceneNum-1 do
if JY.Scene[i]["����"]>0 then
AddPerson(JY.Scene[i]["����"],JY.Scene[i]["����X"],JY.Scene[i]["����Y"],JY.Scene[i]["����"])
end
end
JY.SubScene=JY.Base["��ǰ����"]
JY.EventID=JY.Base["��ǰ�¼�"]
JY.CurrentBGM=JY.Base["��ǰ����"]
JY.LLK_N=0
if CC.font==1 then
CC.FontName=CONFIG.FontName2
else
CC.FontName=CONFIG.FontName
end
if id>0 then
if ((JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_START) and JY.Base["ս���浵"]==0) then
DrawSMap()
end
JY.Status=JY.Base["��ǰ״̬"]
if JY.Base["ս���浵"]==1 then
 WarLoad(id)
end
if JY.CurrentBGM>=0 then
PlayBGM(JY.CurrentBGM)
end
Light()
end
end

function fileexist(filename)--����ļ��Ƿ����
local inp=io.open(filename,"rb")
if inp==nil then
return false
end
inp:close()
return true
end

function copyfile(source,destination)
local sourcefile=io.open(source,"rb")
local destinationfile=io.open(destination,"wb")
destinationfile:write(sourcefile:read("*a"))
sourcefile:close()
destinationfile:close()
end

-- д��Ϸ����
-- id=0 �½��ȣ�=1/2/3 ����
function SaveRecord(id)-- д��Ϸ����
local t1=lib.GetTime()
if JY.Status==GAME_WMAP then
JY.Base["ս���浵"]=1
else
JY.Base["ս���浵"]=0
end
JY.Base["ʱ��"]=string.sub(os.date("%m/%d/%y %X"),0,14)
JY.Base["��ǰ״̬"]=JY.Status
JY.Base["��ǰ�¼�"]=JY.EventID
JY.Base["��ǰ����"]=JY.SubScene
JY.Base["��ǰ����"]=JY.CurrentBGM
for i=1,JY.SceneNum-1 do
JY.Scene[i]["����"]=0
JY.Scene[i]["����X"]=0
JY.Scene[i]["����Y"]=0
JY.Scene[i]["����"]=0
end
local n=#JY.Smap
for i=1,math.min(n,JY.SceneNum-1) do
JY.Scene[i]["����"]=JY.Smap[i][1]
JY.Scene[i]["����X"]=JY.Smap[i][2]
JY.Scene[i]["����Y"]=JY.Smap[i][3]
JY.Scene[i]["����"]=JY.Smap[i][4]
end
local data=Byte.create(4*8)
--��ȡsavedata
Byte.set16(data,0,CC.font)
Byte.set16(data,2,CC.MusicVolume)
Byte.set16(data,4,CC.SoundVolume)
Byte.set16(data,6,CC.zdby)
Byte.set16(data,8,CC.cldh)
Byte.set16(data,10,CC.MoveSpeed)
Byte.savefile(data,CC.SavedataFile,0,4*8)
--��ȡR*.idx�ļ�
Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8)
local idx={}
idx[0]=100
for i=1,8 do
idx[i]=Byte.get32(data,4*(i-1))
end
--дR*.grp�ļ�
if true then
copyfile(CC.R_GRPFilename[0],CC.R_GRPFilename[id])
end
Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0])
Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum)
lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1))
end

function GetDataFromStruct(data,offset,t_struct,key)--�����ݵĽṹ�з������ݣ�����ȡ����
local t=t_struct[key]
local r
if t[2]==0 then
if t[3]==1 then
r=Byte.get8(data,t[1]+offset)
else
r=Byte.get16(data,t[1]+offset)
end
elseif t[2]==1 then
r=Byte.getu16(data,t[1]+offset)
elseif t[2]==2 then
if CC.SrcCharSet==1 then
r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0)
else
r=Byte.getstr(data,t[1]+offset,t[3])
end
end
return r
end

function SetDataFromStruct(data,offset,t_struct,key,v)--�����ݵĽṹ�з������ݣ���������
local t=t_struct[key]
if t[2]==0 then
if t[3]==1 then
Byte.set8(data,t[1]+offset,v)
else
Byte.set16(data,t[1]+offset,v)
end
elseif t[2]==1 then
Byte.setu16(data,t[1]+offset,v)
elseif t[2]==2 then
local s
if CC.SrcCharSet==1 then
s=lib.CharSet(v,1)
else
s=v
end
Byte.setstr(data,t[1]+offset,t[3],s)
end
end

function GetPersonData(offset,t_struct,key)
if t_struct[key][4] then
return GetDataFromStruct(JY.Data_Person,offset,t_struct,key)
else
return GetDataFromStruct(JY.Data_Person_Base,offset,t_struct,key)
end
end

function between(v,Min,Max)
if Min>Max then
Min,Max=Max,Min
end
if v>=Min and v<=Max then
return true
end
return false
end

function Light()--��������
if JY.Dark then
JY.Dark=false
lib.ShowSlow(CC.FrameNum,0)
lib.GetKey()
end
end

function Dark()--�������
if not JY.Dark then
JY.Dark=true
lib.ShowSlow(CC.FrameNum,1)
lib.GetKey()
end
end

--����MP3
function PlayBGM(id)
id=id or 0
JY.CurrentBGM=id
if JY.EnableMusic==0 then
return 
end
if id>=0 and id<=19 then
lib.PlayMIDI(string.format(CC.BGMFile,id))
end
end

function StopBGM()
JY.CurrentBGM=-1
lib.PlayMIDI("")
end

--������Чe**
function PlayWavE(id)--������Чe**
if JY.EnableSound==0 then
return 
end
if id>=0 then
lib.PlayWAV(string.format(CC.EFile,id))
end
end

--�����Ի���ʾ��Ҫ���ַ�������ÿ��n�������ַ���һ���Ǻ�
function GenTalkString(str,n)--�����Ի���ʾ��Ҫ���ַ���
local tmpstr=""
local num=0
for s in string.gmatch(str .. "*","(.-)%*") do--ȥ���Ի��е�����*. �ַ���β����һ���Ǻţ������޷�ƥ��
tmpstr=tmpstr .. s
end
local newstr=""
while #tmpstr>0 do
num=num+1
local w=0
while w<#tmpstr do
local v=string.byte(tmpstr,w+1)--��ǰ�ַ���ֵ
if v>=128 then
w=w+2
else
w=w+1
end
if w >=2*n-1 then--Ϊ�˱����������ַ�
break
end
end
if w<#tmpstr then
if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*"
tmpstr=string.sub(tmpstr,w+2,-1)
else
newstr=newstr .. string.sub(tmpstr,1,w) .. "*"
tmpstr=string.sub(tmpstr,w+1,-1)
end
else
newstr=newstr .. tmpstr
break
end
end
return newstr,num
end

function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--ͨ�ò˵�����
if JY.Status==GAME_START then
local mstr="����־Ӣ�ܴ����̰�"
local msize=50
DrawString(160,30,mstr,M_Orange,msize)
mstr="v"..JY.Base["�����汾"]
DrawString(310,400,mstr,M_Orange,msize)
end
local w=0
local h=0--�߿�Ŀ��
local i=0
local num=0--ʵ�ʵ���ʾ�˵���
local newNumItem=0--�ܹ���ʾ���ܲ˵�����
size=size or CC.Fontbig
size=16
color=color or M_Orange
selectColor=selectColor or M_White
lib.GetKey()
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local newMenu={}-- �����µ����飬�Ա�����������ʾ�Ĳ˵���
--�����ܹ���ʾ���ܲ˵�����
for i=1,numItem do
if menuItem[i][3]>0 then
newNumItem=newNumItem+1
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i,1}--���������[4],�����ԭ����Ķ�Ӧ
--���������[5], ������� 123 ������
if string.sub(menuItem[i][1],1,1)=="@" then
newMenu[newNumItem][1]=string.sub(menuItem[i][1],2)
newMenu[newNumItem][5]=2
end
end
end
--����ʵ����ʾ�Ĳ˵�����
if numShow==0 or numShow > newNumItem then
num=newNumItem
else
num=numShow
end
--����߿�ʵ�ʿ��
local maxlength=0
if x2==0 and y2==0 then
for i=1,newNumItem do
if string.len(newMenu[i][1])>maxlength then
maxlength=string.len(newMenu[i][1])
end
end
w=size*maxlength/2+2*CC.MenuBorderPixel--���հ�����ּ����ȣ�һ����4������
h=(size+CC.RowPixel)*num+CC.MenuBorderPixel--��֮����4�����أ���������4������
else
w=x2-x1
h=y2-y1
num=math.min(num,(math.modf(h/(size+CC.RowPixel))))
end
local start=1--��ʾ�ĵ�һ��
local current=0--��ǰѡ����
for i=1,newNumItem do
if newMenu[i][3]==2 then
current=i
break
end
end
if current > num then
start=1+current-num
end

if JY.Menu_keep then
start=JY.Menu_start
current=JY.Menu_current
end
local keyPress=-1
local returnValue=0
local x_off,y_off,row_off,h_off=0,0,0,0
if isBox==1 then
x_off=3
y_off=7
row_off=4
h_off=8
w=80
h=16+24*num
elseif isBox==2 then --��ʼ�˵���
x_off=4
y_off=6
row_off=4
h_off=8
w=144
h=16+24*num
elseif isBox==20 then--2�ļӿ�汾���浵������
x_off=4
y_off=6
row_off=4
h_off=8
w=420
h=16+24*num
elseif isBox==3 then--baseon 2���������
x_off=4
y_off=6
row_off=4
h_off=8
w=96
h=16+24*num
elseif isBox==4 then
x_off=11
y_off=9
row_off=0
h_off=12
w=112
h=16+8+20*num
elseif isBox==5 then--����<=8��
x_off=4
y_off=9
row_off=0
h_off=12
w=104
h=16+8+20*num
elseif isBox==6 then--����>8��
x_off=4
y_off=9
row_off=0
h_off=12
w=120-20
h=16+8+20*num
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
if x1==-1 or x1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x1=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x1=16+(640-w)/2
else
x1=(CC.ScreenW-w)/2
end
end
if y1==-1 or y1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y1=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y1=16+(400-h)/2
else
y1=(CC.ScreenH-h)/2
end
end

lib.Debug(string.format("showmenu x=%d,y=%d,width=%d,h =%d isBox=%d",x1,y1,w,8+24*num,isBox))

local function redraw(flag)
if num~=0 then--����������
if isBox==1 then
lib.SetClip(x1,y1,x1+w,y1+8+24*num)
lib.PicLoadCache(4,0*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-8)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,0*2,x1,y1+16+24*num-256,1)
lib.SetClip(0,0,0,0)
elseif isBox==2 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,60*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,60*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==20 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,70*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,70*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==3 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,63*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,63*2,x1,y1+14+24*num-182,1)
lib.SetClip(0,0,0,0)
elseif isBox==4 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==5 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==6 then
lib.SetClip(x1,y1,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-32,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
local nn=newNumItem-num
local nn_row=120
lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1)
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
end
for i=start,start+num-1 do
local drawColor=color--���ò�ͬ�Ļ�����ɫ
local menustr=newMenu[i][1]
local dx=0
if newMenu[i][5]==2 then
dx=size*(maxlength-string.len(menustr))/2/2
end
if i==current then
drawColor=selectColor
end
if isBox==1 then
if i==current then
lib.PicLoadCache(4,2*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,1*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==2 then
if i==current then
lib.PicLoadCache(4,62*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,61*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==20 then
if i==current then
lib.PicLoadCache(4,72*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,71*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==3 then
if i==current then
lib.PicLoadCache(4,65*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,64*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==4 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==5 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==6 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
end
if flag then
lib.Background(x1,y1,x1+w,y1+h,128)
end
end
local wait=true
while wait do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid)
redraw()
ReFresh()
local eventtype,keyPress,mx,my=getkey()
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off))
if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
local sel=limitX(start+current,1,newNumItem)
current=0
PlayWavE(0)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid)
redraw()
ReFresh(CC.OpearteSpeed/2)
if newMenu[sel][2]==nil then
returnValue=newMenu[sel][4]
wait=false
else
redraw()
JY.MenuPic.num=JY.MenuPic.num+1
JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h)
JY.MenuPic.x[JY.MenuPic.num]=x1
JY.MenuPic.y[JY.MenuPic.num]=y1
local r=newMenu[sel][2](newMenu[sel][4])--���ò˵�����
lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num])
JY.MenuPic.num=JY.MenuPic.num-1
if r==1 then
returnValue=newMenu[sel][4]
wait=false
end
end
elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
else
current=0
end
elseif isBox==6 then
local nn=newNumItem-num
local nn_row=120
local nn_x=x1+99
local nn_y=y1+24+nn_row*start/nn
if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
nn_y=MOUSE.y-8
start=1+math.modf((nn_y-y1-24)*nn/nn_row)
start=limitX(start,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
start=limitX(start-1,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
start=limitX(start+1,1,nn+1)
end
current=0
else
current=0
end
end
if returnValue==0 then
PlayWavE(1)
end
lib.LoadSur(sid)
lib.FreeSur(sid)
return returnValue
end

function WarShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--ͨ�ò˵�����
local w=0
local h=0--�߿�Ŀ��
local i=0
local num=0--ʵ�ʵ���ʾ�˵���
local newNumItem=0--�ܹ���ʾ���ܲ˵�����
size=size or CC.Fontbig
size=16
color=color or M_Orange
selectColor=selectColor or M_White
lib.GetKey()
local newMenu={}-- �����µ����飬�Ա�����������ʾ�Ĳ˵���
--�����ܹ���ʾ���ܲ˵�����
for i=1,numItem do
if menuItem[i][3]>0 then
newNumItem=newNumItem+1
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i}--���������[4],�����ԭ����Ķ�Ӧ
end
end
--����ʵ����ʾ�Ĳ˵�����
if numShow==0 or numShow > newNumItem then
num=newNumItem
else
num=numShow
end
--����߿�ʵ�ʿ��
local maxlength=0
if x2==0 and y2==0 then
for i=1,newNumItem do
if string.len(newMenu[i][1])>maxlength then
maxlength=string.len(newMenu[i][1])
end
end
w=size*maxlength/2+2*CC.MenuBorderPixel--���հ�����ּ����ȣ�һ����4������
h=(size+CC.RowPixel)*num+CC.MenuBorderPixel--��֮����4�����أ���������4������
else
w=x2-x1
h=y2-y1
num=math.min(num,(math.modf(h/(size+CC.RowPixel))))
end
local start=1--��ʾ�ĵ�һ��
local current=0--��ǰѡ����
for i=1,newNumItem do
if newMenu[i][3]==2 then
current=i
break
end
end
if current > num then
start=1+current-num
end
if JY.Menu_keep then
start=JY.Menu_start
current=JY.Menu_current
end
local keyPress=-1
local returnValue=0
local x_off,y_off,row_off,h_off=0,0,0,0
if isBox==1 then
x_off=3
y_off=7
row_off=4
h_off=8
w=80
h=16+24*num
elseif isBox==2 then
x_off=4
y_off=6
row_off=4
h_off=8
w=144
h=16+24*num
elseif isBox==3 then--baseon 2���������
x_off=4
y_off=6
row_off=4
h_off=8
w=96
h=16+24*num
elseif isBox==4 then
x_off=11
y_off=9
row_off=0
h_off=12
w=112
h=16+8+20*num
elseif isBox==5 then--����<=8��
x_off=4
y_off=9
row_off=0
h_off=12
w=104
h=16+8+20*num
elseif isBox==6 then--����>8��
x_off=4
y_off=9
row_off=0
h_off=12
w=120-20
h=16+8+20*num
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
if x1==-1 then
x1=(CC.ScreenW-w)/2
end
if y1==-1 then
y1=(CC.ScreenH-h)/2
end
local function redraw(flag)
if num~=0 then--����������
if isBox==1 then
lib.SetClip(x1,y1,x1+w,y1+8+24*num)
lib.PicLoadCache(4,0*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-8)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,0*2,x1,y1+16+24*num-256,1)
lib.SetClip(0,0,0,0)
elseif isBox==2 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,60*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,60*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==3 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,63*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,63*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==4 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==5 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==6 then
lib.SetClip(x1,y1,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-32,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
local nn=newNumItem-num
local nn_row=120
lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1)
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
end
for i=start,start+num-1 do
local drawColor=color--���ò�ͬ�Ļ�����ɫ
local menustr=newMenu[i][1]
if i==current then
drawColor=selectColor
end
if isBox==1 then
if i==current then
lib.PicLoadCache(4,2*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
lib.PicLoadCache(4,1*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==2 then
if i==current then
lib.PicLoadCache(4,62*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
lib.PicLoadCache(4,61*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==3 then
if i==current then
lib.PicLoadCache(4,65*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
lib.PicLoadCache(4,64*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==4 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),M_White)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==5 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),M_White)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==6 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),M_White)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
end
if flag then
lib.Background(x1,y1,x1+w,y1+h,128)
end
end
local wait=true
while wait do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
redraw()
ReFresh()
local eventtype,keyPress,mx,my=getkey()
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off))
if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
local sel=limitX(start+current,1,newNumItem)
current=0
PlayWavE(0)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
redraw()
ReFresh(CC.OpearteSpeed)
if newMenu[sel][2]==nil then
returnValue=newMenu[sel][4]
wait=false
else
redraw()
JY.MenuPic.num=JY.MenuPic.num+1
JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h)
JY.MenuPic.x[JY.MenuPic.num]=x1
JY.MenuPic.y[JY.MenuPic.num]=y1
local r=newMenu[sel][2](newMenu[sel][4])--���ò˵�����
lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num])
JY.MenuPic.num=JY.MenuPic.num-1
if r==1 then
returnValue=newMenu[sel][4]
wait=false
end
end
elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
else
current=0
end
elseif isBox==6 then
local nn=newNumItem-num
local nn_row=120
local nn_x=x1+99
local nn_y=y1+24+nn_row*start/nn
if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
nn_y=MOUSE.y-8
start=1+math.modf((nn_y-y1-24)*nn/nn_row)
start=limitX(start,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
start=limitX(start-1,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
start=limitX(start+1,1,nn+1)
end
current=0
else
current=0
end
end
if returnValue==0 then
PlayWavE(1)
end
return returnValue
end

function SRPG()
if CC.Enhancement then
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==1 then
JY.Person[i]["����"]=0
end
end
end
local step=4
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
Light()
ReFresh()
WarCheckStatus()
local WEA={[0]="��","��","��","�","��","��","��"}
while JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn do
--��X�غ� X
WarDrawStrBoxDelay(string.format('��%d�غ� %s',War.Turn,WEA[War.Weather]),M_White)
WarCheckStatus()
--�Ҿ�����
if JY.Status==GAME_WMAP then
WarDrawStrBoxDelay('��Ҿ���״��',M_White)
War.ControlStatus='select'
War.ControlEnable=true
end
while JY.Status==GAME_WMAP do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
if CC.XYXS then
DrawString(8,CC.ScreenH-24,string.format("%d,%d",War.MX,War.MY),M_White,16)
end
ReFresh()
if opn() then
break
end
end
--AI�ж�
if JY.Status==GAME_WMAP then
War.ControlStatus='AI'
AI()
end
War.Turn=War.Turn+1--�غ�+1
if JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn then
--Weather
local wea=math.random(6)-1
if War.Weather<wea then
War.Weather=War.Weather+1
elseif War.Weather>wea then
War.Weather=War.Weather-1
end
if War.Weather==0 then
War.Weather=5
elseif War.Weather==5 then
War.Weather=0
end
--ȫ���ɲ���
for i,v in pairs(War.Person) do
if v.live then
v.active=true
WarResetStatus(i)
end
end
--�ָ�
WarRest()
end
end
if JY.Status==GAME_WMAP and War.Turn>War.MaxTurn then
if War.Leader1==1 then
WarLastWords(GetWarID(1))
WarAction(18,GetWarID(1))
end
JY.Status=GAME_WARLOSE
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
end
Dark()
end

function ReFresh(n)
n=n or 1
local frame_t=CC.FrameNum*n
local t1,t2
t1=JY.ReFreshTime
t2=lib.GetTime()
if CC.FPS or CC.Debug==1 then
lib.FillColor(4,4,72,20,0)
if t2-t1<frame_t then
lib.DrawStr(4,4,string.format("FPS=%d",30),M_White,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
else
lib.DrawStr(4,4,string.format("FPS=%d",1050/(t2-t1)),M_White,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
end
ShowScreen()--���������תΪ����
if t2-t1<frame_t then
lib.Delay(frame_t+t1-t2)
end
end

function control()
local eventtype,keypress,x,y=getkey()
x,y=MOUSE.x,MOUSE.y
if eventtype==3 and keypress==3 then
return -1
end
local pid=0
if War.SelID>0 then
pid=War.Person[War.SelID].id
elseif War.CurID>0 then
pid=War.Person[War.CurID].id
elseif War.LastID>0 then
pid=War.Person[War.LastID].id
end
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('������Ϸ��',M_White) then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo('����һ����',M_White) then
WarDelay(CC.WarDelay)
JY.Status=GAME_START
else
WarDelay(CC.WarDelay)
JY.Status=GAME_END
end
end
elseif War.CY>1 and MOUSE.HOLD(16+War.BoxWidth*1,32+War.BoxDepth*0,16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*1) then
War.CY=War.CY-1
War.MY=War.MY-1
MOUSE.enableclick=false
elseif War.CY<War.Depth-War.MD+1 and MOUSE.HOLD(16+War.BoxWidth*1,32+War.BoxDepth*(War.MD-1),16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*War.MD) then
War.CY=War.CY+1
War.MY=War.MY+1
MOUSE.enableclick=false
elseif War.CX>1 and MOUSE.HOLD(16+War.BoxWidth*0,32+War.BoxDepth*1,16+War.BoxWidth*1,32+War.BoxDepth*(War.MD-1)) then
War.CX=War.CX-1
War.MX=War.MX-1
MOUSE.enableclick=false
elseif War.CX<War.Width-War.MW+1 and MOUSE.HOLD(16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*1,16+War.BoxWidth*War.MW,32+War.BoxDepth*(War.MD-1)) then
War.CX=War.CX+1
War.MX=War.MX+1
MOUSE.enableclick=false
elseif MOUSE.HOLD(War.MiniMapCX,War.MiniMapCY,War.MiniMapCX+War.Width*4,War.MiniMapCY+War.Depth*4) then
War.CX=limitX(math.modf((x-War.MiniMapCX)/4-War.MW/2)+1,1,War.Width-War.MW+1)
War.CY=limitX(math.modf((y-War.MiniMapCY)/4-War.MD/2)+1,1,War.Depth-War.MD+1)
elseif MOUSE.CLICK(616,81,680,161) then
PersonStatus(pid,"","",1)
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,294,678,313) then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][1] then
DrawSkillStatus(JY.Person[pid]["�ؼ�1"])--��ʾ��������
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,294,714,313) then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][2] then
DrawSkillStatus(JY.Person[pid]["�ؼ�2"])--��ʾ��������
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,294,740,313) then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][3] then
DrawSkillStatus(JY.Person[pid]["�ؼ�3"])--��ʾ��������
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,314,678,333) then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][4] then
DrawSkillStatus(JY.Person[pid]["�ؼ�4"])--��ʾ��������
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,314,714,333) then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][5] then
DrawSkillStatus(JY.Person[pid]["�ؼ�5"])--��ʾ��������
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,314,740,333) then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][6] then
DrawSkillStatus(JY.Person[pid]["�ؼ�6"])--��ʾ��������
end
elseif MOUSE.IN(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) and War.ControlStatus~="checkDX" then
local mx,my=math.modf((x-16)/War.BoxWidth),math.modf((y-32)/War.BoxDepth)
War.InMap=true
War.MX=mx+War.CX
War.MY=my+War.CY
War.CurID=GetWarMap(War.MX,War.MY,2)
if War.CurID>0 then
War.LastID=War.CurID
end
if MOUSE.CLICK(16+War.BoxWidth*mx+1,32+War.BoxDepth*my+1,16+War.BoxWidth*(mx+1)-1,32+War.BoxDepth*(my+1)-1) then
return 2,x,y
else
return 1,x,y
end
else
War.InMap=false
end
return 0
end

function BoxBack()
if War.SelID>0 then
War.MX=War.Person[War.SelID].x
War.MY=War.Person[War.SelID].y
local x,y
x=War.MX-math.modf(War.MW/2)
y=War.MY-math.modf(War.MD/2)
x=limitX(x,1,War.Width-War.MW+1)
y=limitX(y,1,War.Depth-War.MD+1)
if War.CX<x and War.MX>War.CX+War.MW-4 then
for i=War.CX,x do
War.CX=i
WarDelay()
end
elseif War.CX>x and War.MX<War.CX+3 then
for i=War.CX,x,-1 do
War.CX=i
WarDelay()
end
end
if War.CY<y and War.MY>War.CY+War.MD-4 then
for i=War.CY,y do
War.CY=i
WarDelay()
end
elseif War.CY>y and War.MY<War.CY+3 then
for i=War.CY,y,-1 do
War.CY=i
WarDelay()
end
end
War.InMap=true
War.CurID=War.SelID
--War.CurID=0
WarDelay(CC.WarDelay)
end
end

function opn()
local event,x,y=control()
if War.ControlStatus=="select" then
if event>0 then
if between(x,16,79) and between(y,8,23) then
War.FunButtom=1
else
War.FunButtom=0
end
end
if event==-1 then
return ESCMenu()
elseif event==2 then
if War.CurID>0 then--ѡ����
if not War.Person[War.CurID].active and CC.WXXD==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('������ִ����ϣ�',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].enemy and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('�����Ҿ����ӣ�',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].friend and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('���ܲ����Ĳ��ӣ�',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].troubled and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('�����в���ָ�ӣ�',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
else
PlayWavE(0)
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
War.ControlStatus="move"
end
elseif War.InMap then--���ˣ������ڵ�ͼ��Χ��
PlayWavE(0)
War.DXpic=lib.SaveSur(16+War.BoxWidth*(War.MX-War.CX),32+War.BoxDepth*(War.MY-War.CY),16+War.BoxWidth*(War.MX-War.CX+1),32+War.BoxDepth*(War.MY-War.CY+1))
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
WarCheckDX()
ReFresh()
local eventtype,keypress=getkey()
if (eventtype==3 and keypress==3) or MOUSE.CLICK(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) then
break
end
end
PlayWavE(1)
lib.FreeSur(War.DXpic)
end
end
elseif War.ControlStatus=="checkDX" then
if event==2 or event==-1 then
PlayWavE(1)
lib.FreeSur(War.DXpic)
War.ControlStatus="select"
end
elseif War.ControlStatus=="move" then
if event==2 then
if not War.InMap then--���ڵ�ͼ��Χ��
elseif War.Person[War.SelID].enemy and CC.KZAI==false then
--�����Ҿ����ӣ�
PlayWavE(2)
WarDrawStrBoxWaitKey('�����Ҿ����ӣ�',M_White)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
elseif War.Person[War.SelID].friend and CC.KZAI==false then
--���ܲ����Ĳ��ӣ�
PlayWavE(2)
WarDrawStrBoxWaitKey('���ܲ����Ĳ��ӣ�',M_White)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
elseif GetWarMap(War.MX,War.MY,4)==0 or (GetWarMap(War.MX,War.MY,2)>0 and GetWarMap(War.MX,War.MY,2)~=War.SelID) then
--�������ƶ���Χ�
PlayWavE(2)
WarDrawStrBoxWaitKey('�������ƶ���Χ�',M_White)
else
CleanWarMap(10,0)
PlayWavE(0)
War.OldX=War.Person[War.SelID].x
War.OldY=War.Person[War.SelID].y
War_MovePerson(War.MX,War.MY)
War.ControlStatus="actionMenu"
CleanWarMap(4,1)
end
elseif event==-1 then
PlayWavE(1)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
end
elseif War.ControlStatus=="actionMenu" then
local scl=War.SelID
local pid=War.Person[scl].id
BoxBack()
local menux,menuy=0,0
local mx=War.Person[War.SelID].x
local my=War.Person[War.SelID].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-80
else
menux=16+War.BoxWidth*(mx-War.CX+1)
end
local m={
{"������",nil,1},
{"������",nil,0},
{"�����",nil,0},
{"������",WarMagicMenu,1},
{"������",WarItemMenu,1},
{"����Ϣ",nil,1},
{"�ȼ�����",nil,0},
{"�ظ�״̬",nil,0},
{"���ֱ��",nil,0},
{"�õ���Ʒ",nil,0},
}
local menu_num=4
if CC.RWTS then
m[7][3]=1
m[8][3]=1
m[9][3]=1
m[10][3]=1
menu_num=menu_num+3
end
if (between(War.Person[scl].bz,4,6) or War.Person[scl].bz==22) and CC.Enhancement and WarCheckSkill(scl,44) then--����
m[2][1]="��"..JY.Skill[44]["����"]
m[2][3]=1
menu_num=menu_num+1
end
if not (between(War.Person[scl].bz,4,6) or between(War.Person[scl].bz,21,22)) and CC.Enhancement and WarCheckSkill(scl,48) then--����
m[2][1]="��"..JY.Skill[48]["����"]
if m[2][3]==0 then
menu_num=menu_num+1
end
m[2][3]=1
end
if CC.Enhancement and WarCheckSkill(scl,5) then--���
m[3][3]=1
menu_num=menu_num+1
end
menuy=math.min(32+War.BoxDepth*(my-War.CY),CC.ScreenH-32-24*menu_num)
local r=WarShowMenu(m,#m,0,menux,menuy,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if r==1 then
WarSetAtkFW(War.SelID,War.Person[War.SelID].atkfw)
local eid=WarSelectAtk(false,11)
if eid>0 then
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["����"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["�ɷ���"]==1 and JY.Bingzhong[War.Person[scl].bz]["������"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
xsgj=true
elseif WarCheckSkill(eid,42) then--����(�ؼ�)
xsgj=true
end
end
end
end
if xsgj then
--����Ƿ��ڹ�����Χ��
xsgj=false
local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,xs_arrary.num do
if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==scl then
xsgj=true
break
end
end
end
end
if xsgj then
--�������ʣ��Ҿ��佫������150
if CC.Enhancement and WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
WarAtk(eid,scl,1)
WarResetStatus(scl)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--����
if math.random(100)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end

if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
end
end
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(scl,eid)
WarResetStatus(eid)
end
--���ҹ���
if CC.Enhancement and WarCheckSkill(scl,116) then
if JY.Person[War.Person[eid].id]["����"]>0 then
War.Person[eid].troubled=true
War.Person[eid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["����"].."�����ˣ�",M_White)
end
end
--��������
local ydgj=0
if CC.Enhancement and WarCheckSkill(scl,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(scl,108) then
ydgj=1
end
if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["����"]<=0 then
War.YD=1
AI_Sub(scl,1)
end
elseif ydgj==2 then
local yd=eid
while yd~=0 do
if JY.Person[War.Person[yd].id]["����"]<=0 then
yd=AI_Sub(scl,1)
else
break
end
end
end
if CC.Enhancement and (JY.Person[pid]["����"]==59 or WarCheckSkill(scl,114)) then--Ӣ��֮�� ���̹���
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0
if dx>0 and dy==0 then--��ȷ�����������ڹ�������߷���
if GetWarMap(xx-1,yy,2)>0 then--Ȼ��ȷ���Ǳ������������һ��Ķ���
eid2=GetWarMap(xx-1,yy,2)--��ȡ��һ�������id���
if War.Person[eid].enemy==War.Person[eid2].enemy then--���ȷ���������뱻������ͬ��Ӫ
WarAtk(scl,eid2)--����
WarResetStatus(eid2)
end
end
end
if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then--��
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then--��
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then--��
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then--����
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then--����
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then--����
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then--����
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
end
--����
local fsfj=false--װ���������µ����˲��ǹ���ʱ��ɱ����
if CC.Enhancement and WarCheckSkill(scl,105) then
fsfj=true
end
if JY.Person[War.Person[eid].id]["����"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
--ֻ��������ɽ�������������������������ܷ����о�����������
--����������Ϊ��������������ޱ��š������ҡ�������ʱ���ſ��ܲ���������
--����������Ϊ���������������ֶӡ�����ʦ�������ʱ�������ܷ���������
--������Ϊ��������ʱ�������Բ�������
local fj_flag=false
if JY.Bingzhong[War.Person[eid].bz]["�ɷ���"]==1 and JY.Bingzhong[War.Person[scl].bz]["������"]==1 then
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,42) then--����(�ؼ�)
fj_flag=true
end
if fj_flag then
--����Ƿ��ڹ�����Χ��
fj_flag=false
local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,fj_arrary.num do
if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==scl then
fj_flag=true
break
end
end
end
end
if fj_flag then
--�������ʣ��Ҿ��佫������150
if CC.Enhancement and WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
WarAtk(eid,scl,1)
WarResetStatus(scl)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--����
if math.random(100)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["����"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
end
end
end
if War.Person[scl].live then
War.Person[scl].active=false
War.Person[scl].action=0
end
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
elseif r==2 then
local skillid=44
if m[2][1]=="��"..JY.Skill[48]["����"] then
skillid=48
end
WarSetAtkFW(scl,War.Person[scl].atkfw)
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo(string.format("%s��ʹ�ü��ܡ�%s����������",JY.Person[pid]["����"],JY.Skill[skillid]["����"]),M_White) then
CleanWarMap(4,1)
local atkarray=WarGetAtkFW(War.Person[scl].x,War.Person[scl].y,War.Person[scl].atkfw)
local eidarray={}
local eidnum=0
for i=1,atkarray.num do
local ex=atkarray[i][1]
local ey=atkarray[i][2]
if between(ex,1,War.Width) and between(ey,1,War.Depth) then
local eid=GetWarMap(ex,ey,2)
if eid>0 then
if War.Person[scl].enemy~=War.Person[eid].enemy then
if (not War.Person[eid].hide) and War.Person[eid].live then
eidnum=eidnum+1
eidarray[eidnum]=eid
end
end
end
end
end
if eidnum==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey('������Χ��û�ео���',M_White)
else
local n=math.random(2)
if skillid==44 then--����
n=n+math.modf(eidnum/2)+math.random(3)-math.random(4)
elseif skillid==48 then--����
n=n+eidnum-1+math.random(3)-math.random(4)
end
n=limitX(n,2,JY.Skill[skillid]["����1"])
for t=1,n do
local eid,index
if eidnum==0 then
break
elseif eidnum==1 then
index=1
else
index=math.random(eidnum)
end
eid=eidarray[index]
if War.Person[eid].live and War.Person[scl].live and (not War.Person[scl].troubled) then
if skillid==44 then--����
WarAtk(scl,eid,2)
elseif skillid==48 then--����
WarAtk(scl,eid,3)
end
WarResetStatus(eid)
end
if not War.Person[eid].live then
table.remove(eidarray,index)
eidnum=eidnum-1
end
end
if War.Person[scl].live then
War.Person[scl].active=false
War.Person[scl].action=0
end
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
else
CleanWarMap(4,1)
end
elseif r==3 then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo(JY.Person[pid]["����"].."��ʹ�ü��ܡ���䡻��������",M_White) then
local wzmenu={
{"�� ��",nil,1},
{"�� �",nil,1},
{"�� ��",nil,1},
}
if between(War.Weather,0,2) then
wzmenu[1][3]=0
elseif between(War.Weather,4,5) then
wzmenu[3][3]=0
else
wzmenu[2][3]=0
end
local r=ShowMenu(wzmenu,3,0,0,0,0,0,1,1,16,M_White,M_White)
if r>0 then
local str1={"���ܵ����鰡��*��Ӧ���ǵ����󣬸ı������ɣ�",
"�����촫�����ǵ���Ը��*���������ǵ�Ը����*�����������ڴ��������ɣ�",
"��ʼ�����ˣ�*ȫ�彫ʿע�⣬*׼���ж���",
"׼���������꣮*ȫ��վ�ã����ڿ�ʼ���꣮",
"���찡�������ҵĺ����ɣ�*�³����꣬ʩ���˼�ɣ�"}
local str2={"��ҿ����˰ɣ�*������ҵ�������*ƽ�������ĳɹ���",
"�ɹ��ˣ�*����ǳ����˵�������*�ܿ�������������������",
"���еĺ�˳����*��ҶԴ˶��ܾ��ȣ�",
"����������£�",
"�������꣡*���쿪���ˣ�*����վ��������ߣ�"}
if r==3 then
talk(pid,str1[math.random(5)])
else
talk(pid,str1[math.random(3)])
end
if math.random(100)<JY.Person[pid]["����2"] then
if r==1 then
War.Weather=math.random(3)-1
elseif r==2 then
War.Weather=3
else
War.Weather=math.random(2)+3
end
PlayWavE(11)
WarDrawStrBoxWaitKey('�ɹ��ˣ�',M_White)
if r==3 then
talk(pid,str2[math.random(5)])
else
talk(pid,str2[math.random(3)])
end
else
PlayWavE(2)
WarDrawStrBoxWaitKey('ʧ���ˣ�',M_White)
end
WarAddExp(scl,8)
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
end
elseif r==4 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==5 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==6 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==7 then
local djb={}
for i=1,99 do
djb[i]=i
end
local lv=LvMenu(djb)
if lv>0 then
JY.Person[pid]["�ȼ�"]=lv
end
elseif r==8 then
JY.Person[pid]["����"]=JY.Person[pid]["������"]
JY.Person[pid]["ʿ��"]=100
JY.Person[pid]["����"]=JY.Person[pid]["������"]
elseif r==9 then
local bz=War.Person[scl].bz
local bzmenu={}
for index=1,JY.BingzhongNum-1 do
 bzmenu[index]={fillblank(JY.Bingzhong[index]["����"],11),nil,0}
if JY.Bingzhong[index]["��Ч"]==1 then
 bzmenu[index][3]=1
end
end
local r=ShowMenu(bzmenu,JY.BingzhongNum-1,8,0,0,0,0,6,1,16,M_White,M_White)
if r>0 then
bz=r
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Bingzhong[bz]["����"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Bingzhong[bz]["˵��"],18),M_White,size)
if talkYesNo(War.Person[War.SelID].id,"תְΪ"..JY.Bingzhong[bz]["����"].."��*������") then
WarBingZhongUp(War.SelID,bz)
end
end
elseif r==10 then
local wp={}
for wpid=1,JY.ItemNum-1 do
wp[wpid]={fillblank(JY.Item[wpid]["����"],11),nil,0}
if wpid<181 and JY.Item[wpid]["����"]>0 then
wp[wpid][3]=1
end
end
local rr=ShowMenu(wp,#wp,8,0,0,0,0,6,1,16,M_White,M_White)
if rr>0 then
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Item[rr]["����"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Item[rr]["˵��"],18),M_White,size)
if talkYesNo(War.Person[War.SelID].id,"�õ�"..JY.Item[rr]["����"].."��*������") then
for i=1,8 do
if JY.Person[War.Person[War.SelID].id]["����"..i]==0 then
JY.Person[War.Person[War.SelID].id]["����"..i]=rr
break
end
if i==8 and JY.Person[War.Person[War.SelID].id]["����"..i]>0 then
WarDrawStrBoxWaitKey('��������',M_White)
end
end
end
end
elseif r==0 then
CleanWarMap(4,1)
CleanWarMap(10,0)
SetWarMap(War.Person[scl].x,War.Person[scl].y,2,0)
SetWarMap(War.OldX,War.OldY,2,War.SelID)
War.Person[scl].x=War.OldX
War.Person[scl].y=War.OldY
BoxBack()
ReSetAttrib(pid,false)
War.SelID=0
War.ControlStatus="select"
end
else--�쳣����״̬�ظ�
War.ControlStatus="select"
end
return false
end

function WarSelectAtk(flag,fw)
--flag true: select us or friend
--flag fasle: select enemy
flag=flag or false
fw=fw or 0
War.ControlStatus="selectAtk"
local tmp=JY.MenuPic.num
JY.MenuPic.num=0
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
ReFresh()
local event,x,y=control()
if event==1 then
CleanWarMap(10,0)
if GetWarMap(War.MX,War.MY,4)>0 and fw>0 then
local array=WarGetAtkFW(War.MX,War.MY,fw)
for i=1,array.num do
local mx,my=array[i][1],array[i][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
if flag then
SetWarMap(mx,my,10,2)
else
SetWarMap(mx,my,10,1)
end
end
end
end
elseif event==2 then
--if not War.InMap then--��ͼ��Χ��
if GetWarMap(War.MX,War.MY,4)>0 then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then--and eid~=War.SelID then
if flag then--select us or friend
if War.Person[eid].enemy==War.Person[War.SelID].enemy then
PlayWavE(0)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
return eid
else
PlayWavE(2)
WarDrawStrBoxWaitKey('�ǵз����ӣ�',M_White)
end
else--select enemy
if War.Person[eid].enemy~=War.Person[War.SelID].enemy then
PlayWavE(0)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
return eid
else
PlayWavE(2)
WarDrawStrBoxWaitKey('���ܹ����ҷ���',M_White)
end
end
else
PlayWavE(2)
--WarDrawStrBoxWaitKey('û�е��ˣ�',M_White)
end
else
PlayWavE(2)
if flag then
WarDrawStrBoxWaitKey('���ڷ�Χ�ڣ�',M_White)
else
WarDrawStrBoxWaitKey('���ڹ�����Χ�ڣ�',M_White)
end
end
elseif event==-1 then
PlayWavE(1)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
War.ControlStatus="actionMenu"
return 0
end
end
JY.MenuPic.num=tmp
end

function WarCheckDX()
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(War.MX-War.CX)-136
else
menux=16+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=32+War.BoxWidth*(War.MY-War.CY)
end
lib.Background(menux,menuy,menux+136,menuy+86,160)
menux=menux+8
menuy=menuy+8
lib.LoadSur(War.DXpic,menux,menuy)
DrawGameBox(menux,menuy,menux+War.BoxWidth,menuy+War.BoxDepth,M_White,-1)
DrawString(menux+56,menuy+8,"����Ч��",M_White,16)
local T={[0]="����","������","������","����","����","����","����","����",
"����","����","����","����","����","������","������","����",
"����","����","����","����",}
DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],M_White,16)
--ɭ�� 20 ɽ�� 30 ��ׯ 5
--��ԭ 5 ¹կ 30 ��Ӫ 10
-- 00 ƽԭ 01 ɭ�� 02 ɽ�� 03 ���� 04 ���� 05 ��ǽ 06 �ǳ� 07 ��ԭ
-- 08 ��ׯ 09 ���� 0A ���� 0B �ĵ� 0C դ�� 0D ¹�� 0E ��Ӫ 0F ����
-- 10 ����� 11 ���� 12 ���� 13 ����
DrawString(menux,menuy+56,War.DX[dx],M_White,16)
if dx==8 or dx==13 or dx==14 then
DrawString(menux+56,menuy+56,"�лָ�",M_White,16)
end
--��ׯ��¹�ο��Իָ�ʿ���ͱ�������Ӫ���Իָ������������ָܻ�ʿ����
--�������Իָ�������ʿ����Ԯ��������Իָ���������������Իָ�ʿ����
--���κͱ���Ļָ��������ܵ��ӣ�Ҳ����˵�����ڴ�ׯ�������ٳ��лָ��Ա����û�г��лָ��Ա���Ч����ͬ�����������ֻ�ָܻ����������Ӫ������������Իָ���������������£�����ʿ�����ܵõ��Զ��ָ���
end

function fillblank(s,num)
local len=num-string.len(s)
if len<=0 then
return string.sub(s,1,num)
else
local left,right
left=math.modf(len/2)
right=len-left
return string.format(string.format("%%%ds%%s%%%ds",left,right),"",s,"")
end
end

--ʹ�ò���
function WarMagicMenu()
local id=War.SelID
local pid=War.Person[id].id
local bz=JY.Person[pid]["����"]
local lv=JY.Person[pid]["�ȼ�"]
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-104-menu_off
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off
end
local m={}
local n=0
local eid=0
local eid2=0
local eid3=0
local eid4=0
for i=1,JY.MagicNum-1 do
if CC.Enhancement and WarCheckSkill(id,101) then--����ģ��
if GetWarMap(mx-1,my,2)>0 then--��
eid=GetWarMap(mx-1,my,2)
end
if GetWarMap(mx+1,my,2)>0 then--��
eid2=GetWarMap(mx+1,my,2)
end
if GetWarMap(mx,my-1,2)>0 then--��
eid3=GetWarMap(mx,my-1,2)
end
if GetWarMap(mx,my+1,2)>0 then--��
eid4=GetWarMap(mx,my+1,2)
end
end
if WarHaveMagic(id,i) or eid>0 and WarHaveMagic(eid,i) or eid2>0 and WarHaveMagic(eid2,i) or eid3>0 and WarHaveMagic(eid3,i) or eid4>0 and WarHaveMagic(eid4,i) then
n=n+1
if CC.Enhancement and (JY.Person[pid]["����"]==12 or WarCheckSkill(id,112)) then--���ǽ� ����ֵ���ļ���
m[i]={fillblank(JY.Magic[i]["����"],8)..string.format("% 2d",math.modf(JY.Magic[i]["����"]/2)),nil,1}
else
m[i]={fillblank(JY.Magic[i]["����"],8)..string.format("% 2d",JY.Magic[i]["����"]),nil,1}
end
else
m[i]={"",nil,0}
end
end
menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-(16+8+20*math.min(n,8))-menu_off)
local r
if n==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey("û�п��ò��ԣ�",M_White)
return 0
elseif n<=8 then
r=WarShowMenu(m,JY.MagicNum-1,0,menux,menuy,0,0,5,1,16,M_White,M_White)
else
r=WarShowMenu(m,JY.MagicNum-1,8,menux,menuy,0,0,6,1,16,M_White,M_White)
end
if r>0 then
local clxh=JY.Magic[r]["����"]
if CC.Enhancement and (JY.Person[pid]["����"]==12 or WarCheckSkill(id,112)) then--���ǽ� ����ֵ���ļ���
clxh=math.modf(clxh/2)
end
if JY.Person[pid]["����"]<clxh then
PlayWavE(2)
WarDrawStrBoxWaitKey("����ֵ���㣮",M_White)
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
if WarMagicMenu_sub(id,r,false) then
if CC.Enhancement and (JY.Person[pid]["����"]==12 or WarCheckSkill(id,112)) then--���ǽ� ����ֵ���ļ���
JY.Person[pid]["����"]=JY.Person[pid]["����"]-math.modf(JY.Magic[r]["����"]/2)
else
JY.Person[pid]["����"]=JY.Person[pid]["����"]-JY.Magic[r]["����"]
end
JY.MenuPic.num=MenuPicNum
return 1
end
JY.MenuPic.num=MenuPicNum
end
end
return 0
end

function WarMagicMenu_sub(id,r,ItemFlag)
local kind=JY.Magic[r]["����"]
if kind==1 then--��ϵ
if between(War.Weather,4,5) then
WarDrawStrBoxConfirm("���첻��ʹ�û𹥣�",M_White)
else
WarDrawStrBoxDelay("�û𹥹������ˣ�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["����"].."֮��",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ч����Χ"]==11 then
if JY.Person[War.Person[eid].id]["����"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("������ɭ�֡���ԭ��ƽԭ���ǳأ�*���ڵĳ��ϲ���ʹ�ã�",M_White)
end
end
end
elseif kind==2 then--ˮϵ
WarDrawStrBoxDelay("��ˮ���������ˣ�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["����"].."֮��",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ч����Χ"]==11 then
if JY.Person[War.Person[eid].id]["����"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("������������ƽԭ��*���ڵĳ��ϲ���ʹ�ã�",M_White)
end
end
elseif kind==3 then--��ʯϵ
WarDrawStrBoxDelay("����ʯ�������ˣ�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["����"].."֮��",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ч����Χ"]==11 then
if JY.Person[War.Person[eid].id]["����"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("������ɽ�ء��ĵأ�*���ڵĳ��ϲ���ʹ�ã�",M_White)
end
end
elseif kind==4 then--���鱨ϵ
WarDrawStrBoxDelay("ʹ���˻��ң�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==5 then--ǣ��ϵ
WarDrawStrBoxDelay("�ش����ʿ����",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==6 then--����ϵ
WarDrawStrBoxDelay("�ָ�ʿ��ֵ��",M_White)
--�ָ���Χ�ڵ�ʿ��ֵ���ӣ�
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==7 then--Ԯ��ϵ
WarDrawStrBoxDelay("�ָ�������",M_White)
--�ָ���Χ�ڵı�������
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==8 then--����ϵ
WarDrawStrBoxDelay("�ָ�������ʿ��ֵ��",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==9 then--��ϵ
WarDrawStrBoxDelay("�ö��������ˣ�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["����"].."֮��",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ч����Χ"]==11 then
if JY.Person[War.Person[eid].id]["����"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("δ֪����������޷�ʹ�ã�",M_White)
end
end
elseif kind==10 then--����ϵ
if between(War.Weather,3,5) then
WarDrawStrBoxDelay("�����׹������ˣ�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["����"].."֮��",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ч����Χ"]==11 then
if JY.Person[War.Person[eid].id]["����"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("���첻��ʹ�����ף�",M_White)
end
end
else
WarDrawStrBoxConfirm("���첻��ʹ�����ף�",M_White)
end
elseif kind==11 then--ը��
WarDrawStrBoxDelay("��ը���������ˣ�",M_White)
WarSetAtkFW(id,JY.Magic[r]["ʩչ��Χ"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ч����Χ"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay("Ͷ��ը����",M_White)
WarMagic(id,eid,r,ItemFlag)
return true
else
WarDrawStrBoxConfirm("δ֪����������޷�ʹ�ã�",M_White)
end
end
end
return false
end

function WarMagicHitRatio(wid,eid,mid)
if between(JY.Magic[mid]["����"],6,8) then
return 1
end
local p1=JY.Person[War.Person[wid].id]
local p2=JY.Person[War.Person[eid].id]
local a=p1["����2"]*p1["�ȼ�"]/100+p1["����2"]
local b=(p2["����2"]*p2["�ȼ�"]/100+p2["����2"])/4
if CC.Enhancement then
if JY.Magic[mid]["����"]==2 and (WarCheckSkill(eid,3) or WarCheckSkill(eid,23)) then--ˮ��/�ټ�
a=1
b=2
end
if JY.Magic[mid]["����"]==1 and WarCheckSkill(eid,4) then--����
a=1
b=2
end
if JY.Magic[mid]["����"]==4 and WarCheckSkill(eid,20) then--����
a=1
b=2
end
if WarCheckSkill(wid,17) then--����
a=a*2
end
if WarCheckSkill(eid,18) then--ʶ��
b=b*2
end
end
if JY.Magic[mid]["����"]==4 then
b=b*2
end
if p2["����"]==13 or p2["����"]==16 or p2["����"]==19 then
b=b*1.5
end
local v=1-b/a
v=limitX(v,0,1)
return v
end

--����ʹ��Ч��
function WarMagic(wid,eid,mid,ItemFlag)
War.ControlStatus="actionMenu"
ItemFlag=ItemFlag or false
local mx=War.Person[eid].x
local my=War.Person[eid].y
local d1,d2=WarAutoD(wid,eid)
local atkarray=WarGetAtkFW(mx,my,JY.Magic[mid]["Ч����Χ"])
War.Person[wid].action=2
War.Person[wid].frame=0
War.Person[wid].d=d1
WarDelay(4)
PlayWavE(8)
WarDelay(8)
PlayWavE(39)
WarDelay(12)
War.Person[wid].action=0
for i=atkarray.num,1,-1 do
local x,y=atkarray[i][1],atkarray[i][2]
local id=GetWarMap(x,y,2)
if id>0 and War.Person[id].live and (not War.Person[id].hide) then
if War.Person[id].enemy==War.Person[eid].enemy then
else
table.remove(atkarray,i)
atkarray.num=atkarray.num-1
end
else
table.remove(atkarray,i)
atkarray.num=atkarray.num-1
end
end
for i=1,atkarray.num do
local x,y=atkarray[i][1],atkarray[i][2]
local id=GetWarMap(x,y,2)
if id>0 and War.Person[id].live and (not War.Person[id].hide) then--table.remove���ȻΪtrue
if War.Person[id].enemy==War.Person[eid].enemy then--table.remove���ȻΪtrue
local id1=War.Person[wid].id
local id2=War.Person[id].id
local hitratio=WarMagicHitRatio(wid,id,mid)
if ItemFlag then
hitratio=1
end
local hurt,sq_hurt,jy,jy2=WarMagicHurt(wid,id,mid,ItemFlag)
d1,d2=WarAutoD(wid,id)
if between(JY.Magic[mid]["����"],6,8) then
if JY.Magic[mid]["����"]==6 then
--����ʿ���ָ�ֵ�����Ի����������������ȼ���10
--ʿ���ָ��������ֵ��һ�������������0��������ʿ���ָ�ֵ��10��1��֮�䡣
--����Ч��������ʿ���ָ�ֵ��ʿ���ָ��������ֵ
if ItemFlag then
sq_hurt=JY.Magic[mid]["Ч��"]
else
sq_hurt=JY.Magic[mid]["Ч��"]+JY.Person[id1]["�ȼ�"]/10
end
sq_hurt=math.modf(sq_hurt*(1+math.random()/10))
sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["ʿ��"])
hurt=-1
if atkarray.num==1 then
WarDrawStrBoxDelay(JY.Person[id2]["����"].."��ʿ��ֵ������",M_White)
end
elseif JY.Magic[mid]["����"]==7 then
--���������ָ�ֵ�����Ի����������������������������ȼ���20
--�����ָ��������ֵ��һ�������������0�������������ָ�ֵ��10��1��֮�䡣
--����Ч�������������ָ�ֵ�������ָ��������ֵ
if ItemFlag then
hurt=JY.Magic[mid]["Ч��"]
else
hurt=JY.Magic[mid]["Ч��"]+JY.Person[id1]["����2"]*JY.Person[id1]["�ȼ�"]/20
if CC.Enhancement then
if WarCheckSkill(eid,41) then--����
hurt=math.modf(hurt*(100+JY.Skill[41]["����1"])/100)
end
end
end
hurt=math.modf(hurt*(1+math.random()/10))
hurt=limitX(hurt,0,JY.Person[id2]["������"]-JY.Person[id2]["����"])
sq_hurt=-1
if atkarray.num==1 then
WarDrawStrBoxDelay(JY.Person[id2]["����"].."�ı���������",M_White)
end
elseif JY.Magic[mid]["����"]==8 then
local hp={600,1200,1800}
local sp={30,40,50}
if ItemFlag then
hurt=hp[JY.Magic[mid]["Ч��"]]
sq_hurt=sp[JY.Magic[mid]["Ч��"]]
else
hurt=hp[JY.Magic[mid]["Ч��"]]+JY.Person[id1]["����2"]*JY.Person[id1]["�ȼ�"]/20
sq_hurt=sp[JY.Magic[mid]["Ч��"]]+JY.Person[id1]["�ȼ�"]/10
if CC.Enhancement then
if WarCheckSkill(eid,41) then--����
hurt=math.modf(hurt*(100+JY.Skill[41]["����1"])/100)
end
end
end
hurt=math.modf(hurt*(1+math.random()/10))
hurt=limitX(hurt,0,JY.Person[id2]["������"]-JY.Person[id2]["����"])
sq_hurt=math.modf(sq_hurt*(1+math.random()/10))
sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["ʿ��"])
if atkarray.num==1 then
WarDrawStrBoxDelay(JY.Person[id2]["����"].."�ı�����ʿ��ֵ������",M_White)
end
end
PlayMagic(mid,x,y,id1)
if hurt>=0 then
War.Person[id].hurt=hurt
WarDelay(8)
War.Person[id].hurt=-1
end
if sq_hurt>=0 then
War.Person[id].hurt=sq_hurt
WarDelay(8)
War.Person[id].hurt=-1
end
local t=16
t=math.min(16,(math.modf(math.max( 2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["����"]
local oldsq=JY.Person[id2]["ʿ��"]
for ii=0,t do
if hurt>0 then
JY.Person[id2]["����"]=oldbl+hurt*ii/t
end
if sq_hurt>0 then
JY.Person[id2]["ʿ��"]=oldsq+sq_hurt*ii/t
end
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
if JY.Magic[mid]["����"]==6 or JY.Magic[mid]["����"]==8 then
WarTroubleShooting(id)
end
if i==atkarray.num then
if atkarray.num>1 then
if JY.Magic[mid]["����"]==6 then
if War.Person[id].enemy then
WarDrawStrBoxDelay("�о���ʿ��ֵ�ָ��ˣ�",M_White)
else
WarDrawStrBoxDelay("�Ҿ���ʿ��ֵ�ָ��ˣ�",M_White)
end
elseif JY.Magic[mid]["����"]==7 then
if War.Person[id].enemy then
WarDrawStrBoxDelay("�о��ı����ָ��ˣ�",M_White)
else
WarDrawStrBoxDelay("�Ҿ��ı����ָ��ˣ�",M_White)
end
elseif JY.Magic[mid]["����"]==8 then
if War.Person[id].enemy then
WarDrawStrBoxDelay("�о��ı�����ʿ��ֵ�ָ��ˣ�",M_White)
else
WarDrawStrBoxDelay("�Ҿ��ı�����ʿ��ֵ�ָ��ˣ�",M_White)
end
end
end
jy=8
if CC.Enhancement then
jy=JY.Magic[mid]["����"]
end
if (JY.Person[id1]["����"]==13 or JY.Person[id1]["����"]==19) then
jy=math.modf(jy*2)
end
if not (War.Person[wid].enemy or ItemFlag) then
WarAddExp(wid,jy)
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
elseif JY.Magic[mid]["����"]==4 then--���鱨ϵ
jy=8
if CC.Enhancement then
jy=JY.Magic[mid]["����"]
end
if math.random()<hitratio then
War.Person[id].action=4
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=-1
if War.Person[id].troubled then
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[id2]["����"].."���ӻ����ˣ�",M_White)
else
War.Person[id].troubled=true
War.Person[id].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[id2]["����"].."�����ˣ�",M_White)
end
else
War.Person[id].action=3
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
PlayWavE(81)
WarDelay(8)
War.Person[id].hurt=-1
WarDrawStrBoxDelay(JY.Person[id1]["����"].."�ļ�ıʧ���ˣ�",M_White)
end
if i==atkarray.num then
if not (War.Person[wid].enemy or ItemFlag) then
WarAddExp(wid,jy)
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
elseif JY.Magic[mid]["����"]==5 then--ǣ��ϵ
jy=8
if CC.Enhancement then
jy=JY.Magic[mid]["����"]
end
if math.random()<hitratio then
hurt=0
--ʿ�����ˣ����Ի���ʿ�����ˣ��������ȼ���10���������ȼ���10
if ItemFlag then
sq_hurt=math.modf(JY.Magic[mid]["Ч��"]-JY.Person[id2]["�ȼ�"]/10)
else
sq_hurt=math.modf(JY.Magic[mid]["Ч��"]+JY.Person[id1]["�ȼ�"]/10-JY.Person[id2]["�ȼ�"]/10)
end
sq_hurt=limitX(sq_hurt,0,JY.Person[id2]["ʿ��"])
War.Person[id].action=4
War.Person[id].frame=0
War.Person[id].d=d2
WarDrawStrBoxDelay(JY.Person[id2]["����"].."��ʿ��ֵ�½���",M_White)
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=sq_hurt
WarDelay(8)
War.Person[id].hurt=-1
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["����"]
local oldsq=JY.Person[id2]["ʿ��"]
for i=1,t do
JY.Person[id2]["����"]=oldbl-hurt*i/t
JY.Person[id2]["ʿ��"]=oldsq-sq_hurt*i/t
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(eid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(id)
else
War.Person[id].action=3
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=0
PlayWavE(81)
WarDelay(8)
War.Person[id].hurt=-1
WarDrawStrBoxDelay(JY.Person[id1]["����"].."�ļ�ıʧ���ˣ�",M_White)
end
if i==atkarray.num then
if not (War.Person[wid].enemy or ItemFlag) then
WarAddExp(wid,jy)
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
elseif WarMagicCheck(wid,id,mid) then
if math.random()<hitratio then
War.Person[id].action=4
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=hurt
WarDelay(8)
War.Person[id].hurt=-1
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["����"]
local oldsq=JY.Person[id2]["ʿ��"]
for i=1,t do
JY.Person[id2]["����"]=oldbl-hurt*i/t
JY.Person[id2]["ʿ��"]=oldsq-sq_hurt*i/t
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(id)
if CC.Enhancement then
if JY.Magic[mid]["����"]==3 then--��ʯϵ
if WarCheckSkill(wid,15) then--��ɳ
if math.random(100)<=JY.Skill[15]["����1"] then
if JY.Person[id2]["����"]>0 then
if not War.Person[id].troubled then
War.Person[id].troubled=true
War.Person[id].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[id2]["����"].."�����ˣ�",M_White)
end
end
end
end
end
end
if not (War.Person[wid].enemy) then
WarAddExp(wid,jy)
if CC.Enhancement then
local id1=War.Person[wid].id
if JY.Person[id1]["����"]<100 and (not War.Person[wid].enemy) then
JY.Person[id1]["��������"]=JY.Person[id1]["��������"]+2
if JY.Person[id1]["��������"]>=200 then
JY.Person[id1]["��������"]=JY.Person[id1]["��������"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[wid].action
--תȦ����������
War.Person[wid].action=0
for t=1,2 do
War.Person[wid].d=3
WarDelay(3)
War.Person[wid].d=2
WarDelay(3)
War.Person[wid].d=4
WarDelay(3)
War.Person[wid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[wid].action=6
for i=0,256,8 do
War.Person[wid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[wid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["����"].."�ɹ�������һö������",M_White)
ReSetAttrib(id1,false)
War.Person[wid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["����"..n]==0 then
JY.Person[id1]["����"..n]=72
break
end
end
end
end
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
else
War.Person[id].action=3
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=0
PlayWavE(81)
WarDelay(8)
War.Person[id].hurt=-1
if not (War.Person[wid].enemy) then
WarAddExp(wid,jy2)
local id1=War.Person[wid].id
if CC.Enhancement and JY.Person[id1]["����"]<100 and (not War.Person[wid].enemy) then
JY.Person[id1]["��������"]=JY.Person[id1]["��������"]+1
if JY.Person[id1]["��������"]>=200 then
JY.Person[id1]["��������"]=JY.Person[id1]["��������"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[wid].action
--תȦ����������
War.Person[wid].action=0
for t=1,2 do
War.Person[wid].d=3
WarDelay(3)
War.Person[wid].d=2
WarDelay(3)
War.Person[wid].d=4
WarDelay(3)
War.Person[wid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[wid].action=6
for i=0,256,8 do
War.Person[wid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[wid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["����"].."�ɹ�������һö������",M_White)
ReSetAttrib(id1,false)
War.Person[wid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["����"..n]==0 then
JY.Person[id1]["����"..n]=72
break
end
end
end
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
WarDrawStrBoxDelay(JY.Person[id1]["����"].."�ļƲ�ʧ���ˣ�",M_White)
end
end
end
end
end
WarResetStatus(wid)
end

function PlayMagic(mid,x,y,pid)
if CC.cldh==0 then
return
end
local eft=JY.Magic[mid]["����"]
local pic_w,pic_h=lib.PicGetXY(0,eft*2)
local frame=pic_h/pic_w
if eft==241 then
frame=7
elseif eft==242 then
frame=13
elseif eft==243 then
frame=13
end
pic_h=pic_h/frame
local str=JY.Person[pid]["����"]..'�Ĳ���'
local sx,sy
sx=16+War.BoxWidth*(x-War.CX+0.5)-pic_w/2
sy=32+War.BoxDepth*(y-War.CY+1)-pic_h
PlayWavE(JY.Magic[mid]["��Ч"])
local rpt=2
if between(JY.Magic[mid]["����"],4,8) then
rpt=1
end
for i=1,frame do
for n=1,rpt do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
lib.SetClip(sx,sy,sx+pic_w,sy+pic_h)
lib.PicLoadCache(0,eft*2,sx,sy-pic_h*(i-1),1)
lib.SetClip(0,0,0,0)
lib.GetKey()
ReFresh()
end
end
end

function WarMagicCheck(wid,eid,mid)
local kind=JY.Magic[mid]["����"]
local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if between(kind,4,8) or kind==9 or kind==11 then
return true
end
if kind==1 and between(War.Weather,4,5) then
return false
end
if kind==10 and between(War.Weather,3,5) then
return true
end
if CC.Enhancement then
if WarCheckSkill(wid,46) then--����
return true
end
end
if kind==1 and (dx==0 or dx==1 or dx==6 or dx==7) then
return true
end
if kind==2 and (dx==0 or dx==4) then
return true
end
if kind==3 and (dx==2 or dx==11) then
return true
end
return false
end

--�����˺�
function WarMagicHurt(wid,eid,mid,ItemFlag)
ItemFlag=ItemFlag or false
local id1=War.Person[wid].id
local id2=War.Person[eid].id
local p1=JY.Person[id1]
local p2=JY.Person[id2]
local hurt=JY.Magic[mid]["Ч��"]
if ItemFlag then
hurt=hurt-(p2["����2"]*p2["�ȼ�"]/40+p2["����2"])
else
hurt=hurt+(p1["����2"]*p1["�ȼ�"]/40+p1["����2"])*2-(p2["����2"]*p2["�ȼ�"]/40+p2["����2"])
end
if p2["����"]==13 or p2["����"]==16 or p2["����"]==19 then
hurt=hurt/2
end

--������������������У��Ҳ����ǽ���ϵ����
--���Թ���ɱ�ˣ����Թ���ɱ�ˣ����Թ���ɱ�ˡ�4
--�����ǰ���������죬�Ҳ���������ϵ����
--���Թ���ɱ�ˣ����Թ���ɱ�ˣ����Թ���ɱ�ˡ�4

local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if JY.Magic[mid]["����"]==1 and dx==1 then
hurt=hurt*1.25
end
if JY.Magic[mid]["����"]==2 and between(War.Weather,4,5) then
hurt=hurt*1.25
end
if JY.Magic[mid]["����"]==10 and between(War.Weather,4,5) then
hurt=hurt*1.1
end
local item_atk=0
if p1["����"]>0 then
item_atk=item_atk+JY.Item[p1["����"]]["���Թ���"]
end
if p1["����"]>0 then
item_atk=item_atk+JY.Item[p1["����"]]["���Թ���"]
end
if p1["����"]>0 then
item_atk=item_atk+JY.Item[p1["����"]]["���Թ���"]
end
if item_atk~=0 then
hurt=hurt*(100+item_atk)/100
end
if CC.Enhancement then
if JY.Magic[mid]["����"]==1 and WarCheckSkill(wid,12) then--���
hurt=hurt*(100+JY.Skill[12]["����1"])/100
end
if JY.Magic[mid]["����"]==2 and WarCheckSkill(wid,11) then--ˮ��
hurt=hurt*(100+JY.Skill[11]["����1"])/100
end
if JY.Magic[mid]["����"]==3 and WarCheckSkill(wid,14) then--��ʯ
hurt=hurt*(100+JY.Skill[14]["����1"])/100
end
if (between(JY.Magic[mid]["����"],1,3) or between(JY.Magic[mid]["����"],9,10)) and WarCheckSkill(wid,39) then--����
hurt=hurt*(100+JY.Skill[39]["����1"])/100
end
if (between(JY.Magic[mid]["����"],1,3) or between(JY.Magic[mid]["����"],9,10)) and WarCheckSkill(wid,50) then--��ı
hurt=hurt*(100+JY.Skill[50]["����1"])/100
end
if JY.Magic[mid]["����"]==1 and WarCheckSkill(eid,13) then--���
hurt=hurt*(100-JY.Skill[13]["����1"])/100
end
if JY.Magic[mid]["����"]==1 and WarCheckSkill(eid,4) then--����
hurt=1
end
if JY.Magic[mid]["����"]==2 and WarCheckSkill(eid,3) then--ˮ��
hurt=1
end
if (between(JY.Magic[mid]["����"],1,3) or between(JY.Magic[mid]["����"],9,10)) then
if WarCheckSkill(eid,16) then--����
hurt=hurt*(100-JY.Skill[16]["����1"])/100
end
if WarCheckSkill(eid,37) then--����
hurt=hurt*(100-JY.Skill[37]["����1"])/100
end
end
if WarCheckSkill(eid,23) then--�ټ�
if JY.Magic[mid]["����"]==1 then
hurt=hurt*(100+JY.Skill[23]["����2"])/100
end
if JY.Magic[mid]["����"]==2 then
hurt=1
end
end
end
hurt=math.modf(hurt*(1+math.random()/50))
if hurt<1 then
hurt=1
end
-- ��������˺����ڷ������������򹥻��˺�=����������
if hurt>p2["����"] then
hurt=p2["����"]
end
--ʿ�������������˺��£��������ȼ���5����3
local sq_hurt=math.modf(hurt/(p2["�ȼ�"]+5)/3)
if sq_hurt==0 then
if hurt>0 then
sq_hurt=1
else
sq_hurt=0
end
end
sq_hurt=limitX(sq_hurt,0,p2["ʿ��"])
--����ֵ���
local jy=0
local jy2=0--����ʧ��ʱ�ľ���
--�о����Ӳ��ܻ�þ���ֵ��
if p1["�ȼ�"]<99 and (not War.Person[wid].enemy) then--and (not War.Person[wid].friend) then
--����ֵ�������ֹ��ɣ���������ֵ�ͽ�������ֵ��
local part1,part2=0,0
--���������ȼ����ڵ��ڷ������ȼ�ʱ��
if p1["�ȼ�"]<=p2["�ȼ�"] then
--��������ֵ�����������ȼ����������ȼ���3����2
part1=(p2["�ȼ�"]-p1["�ȼ�"]+3)*2
--�����������ֵ����16�����������ֵ��16��
if part1>16 then
part1=16
end
--��߻�ȡ����
if CC.Enhancement then
part1=(p2["�ȼ�"]-p1["�ȼ�"]+5)*2
if part1>24 then
part1=24
end
end
--���������ȼ����ڷ������ȼ�ʱ��
else
--��������ֵ��4
part1=4
if CC.Enhancement then
part1=8--��߻�ȡ����
end
end
--���ɱ�����ˣ����Ի�ý�������ֵ��
if hurt==p2["����"] then
--���ɱ���о�����
if War.Person[eid].leader then
--��������ֵ��48
part2=48
--���ɱ���Ĳ��ǵо��������ҵо��ȼ������Ҿ�
elseif p2["�ȼ�"]>p1["�ȼ�"] then
--��������ֵ��32
part2=32
--���ɱ���Ĳ��ǵо��������ҵо��ȼ����ڵ����Ҿ�
else
--��������ֵ��64�£��������ȼ����������ȼ���2��
part2=math.modf(64/(p1["�ȼ�"]-p2["�ȼ�"]+2))
--��߻�ȡ����
if CC.Enhancement then
part2=32-(p1["�ȼ�"]-p2["�ȼ�"])*4
part2=limitX(part2,8,48)
end
end
end
--���ջ�õľ���ֵ����������ֵ����������ֵ��
jy=part1+part2
jy2=part1
end
if JY.Magic[mid]["����"]==11 then
hurt=limitX((math.random(15)+90)*15,0,p2["����"])
sq_hurt=limitX(math.random(10)+30,0,p2["ʿ��"])
jy=0
jy2=0
end
return hurt,sq_hurt,jy,jy2
end

function WarItemMenu()
local id=War.SelID
local pid=War.Person[id].id
if JY.Person[pid]["����1"]==0 then
WarDrawStrBoxWaitKey("û�е��ߣ�",M_White)
return
end
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off
end
menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-112-menu_off)
local m={
{"��ʹ��",WarItemMenu_sub,1},
{"������",WarItemMenu_sub,1},
{"������",WarItemMenu_sub,1},
{"���ۿ�",WarItemMenu_sub,1},
}
local r=WarShowMenu(m,4,0,menux,menuy,menux+80,menuy+112,1,1,16,M_White,M_White)
if r>0 then
return 1
else
return 0
end
end

function WarItemMenu_sub(kind)
local id=War.SelID
local pid=War.Person[id].id
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off*2
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off*2
end
menuy=math.min(12+War.BoxDepth*(my-War.CY)+menu_off*2,CC.ScreenH-16-132-menu_off*2)
local m={}
for i=1,8 do
local itemid=JY.Person[pid]["����"..i]
if itemid>0 then
if kind==1 then
m[i]={fillblank(JY.Item[itemid]["����"],10),Item_Use,1}
elseif kind==2 then
m[i]={fillblank(JY.Item[itemid]["����"],10),Item_Send,1}
elseif kind==3 then
m[i]={fillblank(JY.Item[itemid]["����"],10),Item_Scrap,1}
elseif kind==4 then
m[i]={fillblank(JY.Item[itemid]["����"],10),Item_Check,1}
else
m[i]={fillblank(JY.Item[itemid]["����"],10),nil,1}
end
else
m[i]={"",nil,0}
end
end
local r=WarShowMenu(m,8,0,menux,menuy,0,0,4,1,16,M_White,M_White)
if r>0 then
return 1
else
return 0
end
end

--ʹ�õ���
function Item_Use(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["����"..i]
local kind=JY.Item[itemid]["����"]
if between(kind,1,2) then
local mid=JY.Item[itemid]["Ч��"]
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
if WarMagicMenu_sub(id,mid,true) then
JY.MenuPic.num=MenuPicNum
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
return 1
end
JY.MenuPic.num=MenuPicNum
elseif kind==3 then
if not WarDrawStrBoxYesNo(string.format('�����ӱ��%s��',JY.Bingzhong[JY.Item[itemid]["Ч��"]]["����"]),M_White) then
return 0
elseif JY.Item[itemid]["�����"]>0 and JY.Person[pid]["����"]~=JY.Item[itemid]["�����"] then
PlayWavE(2)
WarDrawStrBoxDelay("��Ҫ"..JY.Bingzhong[JY.Item[itemid]["�����"]]["����"].."��",M_White)
return 0
elseif JY.Person[pid]["�ȼ�"]<JY.Item[itemid]["��ȼ�"] then
PlayWavE(2)
WarDrawStrBoxDelay("�ȼ����㣮",M_White)
return 0
else
WarBingZhongUp(War.SelID,JY.Item[itemid]["Ч��"])
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
return 1
end
elseif kind==8 then--������
if not WarDrawStrBoxYesNo('��������ֵ��',M_White) then
return 0
elseif JY.Person[pid]["����"]>=100 then
PlayWavE(2)
WarDrawStrBoxDelay("�޷�������",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--ʹ����Ʒ����
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--תȦ����������
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["����"]=JY.Person[pid]["����"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�Ļ�������������"..JY.Person[pid]["����"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["����"..i]=0
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
return 1
end
elseif kind==9 then--������
if not WarDrawStrBoxYesNo('��������ֵ��',M_White) then
return 0
elseif JY.Person[pid]["����"]>=100 then
PlayWavE(2)
WarDrawStrBoxDelay("�޷�������",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--ʹ����Ʒ����
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--תȦ����������
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["����"]=JY.Person[pid]["����"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�Ļ�������������"..JY.Person[pid]["����"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["����"..i]=0
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
return 1
end
elseif kind==10 then--ͳ����
if not WarDrawStrBoxYesNo('����ͳ��ֵ��',M_White) then
return 0
elseif JY.Person[pid]["ͳ��"]>=100 then
PlayWavE(2)
WarDrawStrBoxDelay("�޷�������",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--ʹ����Ʒ����
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--תȦ����������
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["ͳ��"]=JY.Person[pid]["ͳ��"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�Ļ���ͳ��������"..JY.Person[pid]["ͳ��"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["����"..i]=0
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
return 1
end
elseif kind==13 then--������
if not WarDrawStrBoxYesNo(JY.Person[pid]["����"]..'�����ȼ���',M_White) then
return 0
elseif JY.Person[pid]["�ȼ�"]>=99 then
PlayWavE(2)
WarDrawStrBoxDelay("�޷�������",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--ʹ����Ʒ����
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--תȦ����������
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["�ȼ�"]=JY.Person[pid]["�ȼ�"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�ĵȼ�������"..JY.Person[pid]["�ȼ�"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["����"..i]=0
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
return 1
end
else
PlayWavE(2)
WarDrawStrBoxDelay("û����ʹ�õĵ��ߣ�",M_White)
return 0
end
end

--�����ˣ�
function Item_Send(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["����"..i]
WarSetAtkFW(War.SelID,21)
local eid=WarSelectAtk(true,11)
if eid>0 then
local EID=War.Person[eid].id
if JY.Person[EID]["����8"]>0 then
PlayWavE(2)
WarDrawStrBoxDelay("Я��Ʒ�Ѿ����ˣ������ٸ��ˣ�",M_White)
return 0
else
for n=1,8 do
if JY.Person[EID]["����"..n]==0 then
JY.Person[EID]["����"..n]=itemid
break
end
end
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
WarDrawStrBoxWaitKey("������"..JY.Item[itemid]["����"].."��",M_White)
ReSetAttrib(pid,false)
ReSetAttrib(EID,false)
return 1
end
else
return 0
end
end

function Item_Scrap(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["����"..i]
WarDrawStrBoxWaitKey("������"..JY.Item[itemid]["����"].."��",M_White)
for n=i,7 do
JY.Person[pid]["����"..n]=JY.Person[pid]["����"..(n+1)]
end
JY.Person[pid]["����8"]=0
ReSetAttrib(id,false)
return 1
end

function Item_Check(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["����"..i]
 DrawItemStatus(itemid,pid)--��ʾ��Ʒ����
return 0
end

function WarAutoD(id1,id2)
local x1,y1=War.Person[id1].x,War.Person[id1].y
local x2,y2=War.Person[id2].x,War.Person[id2].y
local dx=math.abs(x1-x2)
local dy=math.abs(y1-y2)
if dx==0 and dy==0 then
return War.Person[id1].d,War.Person[id1].d
end
if dy>dx then
if y1>y2 then
return 2,1
else
return 1,2
end
else
if x1>x2 then
return 3,4
else
return 4,3
end
end
end

-- BZSuper(bz1,bz2)
-- ���ر��ֿ��ƹ�ϵ
-- true ���� false ��������
function BZSuper(bz1,bz2)
for i=1,9 do
if JY.Bingzhong[bz1]["����"..i]==bz2 then
return true--bz1 ���� bz2
end
end
return false--��������
end

function WarAtkHurt(pid,eid,flag)
flag=flag or 0
local id1=War.Person[pid].id
local id2=War.Person[eid].id
local p1=JY.Person[id1]
local p2=JY.Person[id2]
--��������
local atk=p1["����"]
local def=p2["����"]
--�������������ֿ���
--������Ч�������ؼ�Ч�������ڱ������
if CC.Enhancement and (p1["����"]==10 or WarCheckSkill(pid,110)) then--���ֿ��� װ�����콣��ؿ���
def=def*3/4
elseif CC.Enhancement and (p2["����"]==11 or WarCheckSkill(eid,111)) then--���ֱ����� װ�����G���󲻱�����
def=def*5/4

elseif BZSuper(p1["����"],p2["����"]) then--���ֿ���
def=def*3/4
elseif BZSuper(p2["����"],p1["����"]) then--���ֱ�����
def=def*5/4
end
--����ɱ������
local T={
[0]=0,20,30,0,0,--ɭ�֡�20��ɽ�ء�30
0,0,5,5,0,--��ׯ�� 5 ��ԭ�� 5
0,0,0,30,10,--¹կ��30����Ӫ��10
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0
}
local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
--��������ɱ�ˣ���������������������������ֵ��2������100������ɱ����������100
local hurt=(atk-def/2)
if CC.Enhancement then
hurt=hurt*limitX(100+War.Person[pid].atk_buff-War.Person[eid].def_buff,10,200)/100
if WarCheckSkill(eid,23) then--�ټ�
hurt=hurt*(100-JY.Skill[23]["����1"])/100
end
if WarCheckSkill(eid,47) then--���
hurt=hurt*(100-JY.Skill[47]["����1"])/100
end
else
hurt=hurt*(100-T[dx])/100
end
if flag==1 then--������
hurt=hurt/2
elseif flag==2 or flag==3 then--����/���� �˺�ͳһ����Ϊ�����˺���40%
hurt=hurt*0.4
end
hurt=math.modf(hurt)
if CC.Enhancement then
if WarCheckSkill(eid,43) then--�ǹ�
if hurt>p2["������"]/5 then
hurt=p2["������"]/5
end
end
end
if CC.Enhancement and WarCheckSkill(eid,104) then--���� �������µ� ������ʱ�ض���
if hurt>p2["������"]/5 then
hurt=p2["������"]/5
end
end
if CC.Enhancement and (p1["����"]==60 or WarCheckSkill(pid,115)) then--����֮�� ����ʱ�ض�����
if WarCheckSkill(eid,23) or WarCheckSkill(eid,43) or WarCheckSkill(eid,47) then--ӵ�� �ټ� �ǹ� ��� �ؼ�ʱ������Ч
WarDrawStrBoxDelay('������Ч�޷�����',M_White)
else
if hurt<p2["����"]*0.4 then
hurt=p2["����"]*0.4
end
end
end
if hurt<atk/20 then
hurt=math.modf(atk/20)
end
--��������˺�<=0���򹥻��˺�=1��
if hurt<1 then
hurt=1
end
local flag2=0
if hurt>=p2["������"]*0.4 then
flag2=2--����
elseif hurt>=p2["����"]+p2["������"]/5 then
flag2=2--����
elseif hurt<=p2["������"]/5 then
flag2=1--��
end
-- ��������˺����ڷ������������򹥻��˺�=����������
if hurt>p2["����"] then
hurt=p2["����"]
end
--ʿ�������������˺��£��������ȼ���5����3
local sq_hurt=math.modf(hurt/(p2["�ȼ�"]+5)/3)
if sq_hurt==0 then
if hurt>0 then
sq_hurt=1
else
sq_hurt=0
end
end
if CC.Enhancement and (p1["����"]==14 or WarCheckSkill(pid,113)) then--���⵶ ����ʱ������ٵз�ʿ��
sq_hurt=sq_hurt+10
end
sq_hurt=limitX(sq_hurt,0,p2["ʿ��"])
--����ֵ���
local jy=0
--�о����Ӳ��ܻ�þ���ֵ��
if p1["�ȼ�"]<99 and (not War.Person[pid].enemy) then--and (not War.Person[pid].friend) then
--����ֵ�������ֹ��ɣ���������ֵ�ͽ�������ֵ��
local part1,part2=0,0
--���������ȼ����ڵ��ڷ������ȼ�ʱ��
if p1["�ȼ�"]<=p2["�ȼ�"] then
--��������ֵ�����������ȼ����������ȼ���3����2
 part1=(p2["�ȼ�"]-p1["�ȼ�"]+3)*2
--�����������ֵ����16�����������ֵ��16��
if part1>16 then
part1=16
end
--��߻�ȡ����
if CC.Enhancement then
part1=(p2["�ȼ�"]-p1["�ȼ�"]+5)*2
if part1>24 then
part1=24
end
end
--���������ȼ����ڷ������ȼ�ʱ��
else
--��������ֵ��4
part1=4
if CC.Enhancement then
part1=8--��߻�ȡ����
end
end
--���ɱ�����ˣ����Ի�ý�������ֵ��
if hurt==p2["����"] then
--���ɱ���о�����
if War.Person[eid].leader then
--��������ֵ��48
part2=48
--���ɱ���Ĳ��ǵо��������ҵо��ȼ������Ҿ�
elseif p2["�ȼ�"]>p1["�ȼ�"] then
--��������ֵ��32
part2=32
--���ɱ���Ĳ��ǵо��������ҵо��ȼ����ڵ����Ҿ�
else
--��������ֵ��64�£��������ȼ����������ȼ���2��
part2=math.modf(64/(p1["�ȼ�"]-p2["�ȼ�"]+2))
--��߻�ȡ����
if CC.Enhancement then
part2=32-(p1["�ȼ�"]-p2["�ȼ�"])*4
part2=limitX(part2,8,48)
end
end
end
--���ջ�õľ���ֵ����������ֵ����������ֵ��
jy=part1+part2
end
return hurt,sq_hurt,jy,flag2
end

function WarAtk(pid,eid,flag)
flag=flag or 0
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
local hurt,sq_hurt,jy,flag2=WarAtkHurt(pid,eid,flag)
--flag2 0 ��ͨ 1�� 2����
local id1=War.Person[pid].id
local id2=War.Person[eid].id
local str
if flag==1 then
str=JY.Person[id1]["����"]..'�ķ���'
elseif flag==2 then
str=JY.Person[id1]["����"]..'������'
elseif flag==3 then
str=JY.Person[id1]["����"]..'������'
else
str=JY.Person[id1]["����"]..'�Ĺ���'
end
local n=CC.OpearteSpeed
local d1,d2=WarAutoD(pid,eid)
War.Person[pid].d=d1
WarDelay()
if flag2==2 then
PlayWavE(6)
WarAtkWords(pid)
end
War.Person[pid].action=2
War.Person[pid].frame=0
WarDelay()
PlayWavE(War.Person[pid].atkwav)
for i=1,n*2 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
for i=0,3 do
War.Person[pid].frame=i
if i==0 and flag2==2 then
PlayWavE(33)
for t=8,192,8 do
JY.ReFreshTime=lib.GetTime()
War.Person[pid].effect=t
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].hurt=hurt
War.Person[eid].frame=0
War.Person[eid].d=d2
if War.Person[eid].troubled then
PlayWavE(35)
elseif flag2==1 then
War.Person[eid].action=3
PlayWavE(30)
elseif flag2==2 then
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(36)
else
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(35)
end
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
end
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
end
War.Person[eid].effect=0
for i=1,n*2 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[eid].hurt=-1
--�о��������� ��ʾ
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["����"]
local oldsq=JY.Person[id2]["ʿ��"]
for i=0,t do
JY.ReFreshTime=lib.GetTime()
JY.Person[id2]["����"]=oldbl-hurt*i/t
JY.Person[id2]["ʿ��"]=oldsq-sq_hurt*i/t
DrawWarMap()
DrawStatusMini(eid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(eid)
--���� ��ʾ
if CC.Enhancement then
if WarCheckSkill(pid,33) or (pid==3 and JY.EventID>488 and not GetFlag(38)) then--���� ��I֮ս����ͳδ�����ŷɱش�������Ч
if hurt>0 and JY.Person[id1]["����"]<JY.Person[id1]["������"] then
local t=16
hurt=math.modf(hurt*JY.Skill[33]["����1"]/100)
hurt=limitX(hurt,1,JY.Person[id1]["������"]-JY.Person[id1]["����"])
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/25))))
local oldbl=JY.Person[id1]["����"]
for i=0,t do
JY.ReFreshTime=lib.GetTime()
JY.Person[id1]["����"]=oldbl+hurt*i/t
DrawWarMap()
DrawStatusMini(pid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
end
end
end
local flag3=flag2
if flag2==0 then flag3=2 end
if flag2==1 then flag3=1 end
if flag2==2 then flag3=3 end
if CC.Enhancement then
if JY.Person[id2]["ͳ��"]<100 and (not War.Person[eid].enemy) then
JY.Person[id2]["ͳ�ʾ���"]=JY.Person[id2]["ͳ�ʾ���"]+flag3
if JY.Person[id2]["ͳ�ʾ���"]>=200 then
JY.Person[id2]["ͳ�ʾ���"]=JY.Person[id2]["ͳ�ʾ���"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[eid].action
--תȦ����������
War.Person[eid].action=0
for t=1,2 do
War.Person[eid].d=3
WarDelay(3)
War.Person[eid].d=2
WarDelay(3)
War.Person[eid].d=4
WarDelay(3)
War.Person[eid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[eid].action=6
for i=0,256,8 do
War.Person[eid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[eid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id2]["����"].."�ɹ�������һöͳ����",M_White)
ReSetAttrib(id2,false)
War.Person[eid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id2]["����"..n]==0 then
JY.Person[id2]["����"..n]=73
break
end
end
end
end
end
--�����Լ�����
WarAddExp(pid,jy)
if CC.Enhancement then
if JY.Person[id1]["����"]<100 and (not War.Person[pid].enemy) then
JY.Person[id1]["��������"]=JY.Person[id1]["��������"]+flag3
if JY.Person[id1]["��������"]>=200 then
JY.Person[id1]["��������"]=JY.Person[id1]["��������"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[pid].action
--תȦ����������
War.Person[pid].action=0
for t=1,2 do
War.Person[pid].d=3
WarDelay(3)
War.Person[pid].d=2
WarDelay(3)
War.Person[pid].d=4
WarDelay(3)
War.Person[pid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[pid].action=6
for i=0,256,8 do
War.Person[pid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[pid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["����"].."�ɹ�������һö������",M_White)
ReSetAttrib(id1,false)
War.Person[pid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["����"..n]==0 then
JY.Person[id1]["����"..n]=71
break
end
end
end
end
end
if War.Person[pid].active then
War.Person[pid].action=1
else
War.Person[pid].action=0
end
if War.Person[eid].active then
War.Person[eid].action=1
else
War.Person[eid].action=0
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
War.Person[pid].frame=-1
War.Person[eid].frame=-1
War.ControlEnable=War.ControlEnableOld
if CC.Enhancement then
if War.Person[pid].bz==27 and flag==0 then--��Ů������
if JY.Person[id2]["����"]>0 then
WarAtk(pid,eid,3)
end
end
end
end

--WarAction(kind,id1,id2)
-- ս������ʾ���ֶ��� idһ��Ϊ����id
-- kind: 0.ת�� id1����id, id2 ����id 1234��������
-- 1.�Զ�ת��
-- 3.����|�� 4.����|������ 5.����|���� 6.����|����
-- 7.����|�� 8.����|������ 9.����|���� 10.����|����
-- 11.˫��|�� 12.
-- 15.���� 16.����(������) 17.���� 18.����
-- 19.����
function WarAction(kind,id1,id2)
if JY.Status~=GAME_WMAP and JY.Status~=GAME_WARWIN and JY.Status~=GAME_WARLOSE then
return
end
local controlstatus=War.ControlEnable
War.ControlEnable=false
War.InMap=false
id1=id1 or 1
id2=id2 or id1
local pid=GetWarID(id1)
local eid=GetWarID(id2)
local n=CC.OpearteSpeed
WarPersonCenter(pid)
if (not War.Person[pid].live) or War.Person[pid].hide then
elseif kind==0 then
if between(id2,1,4) then
War.Person[pid].action=0
War.Person[pid].frame=0
WarDelay(n)
if War.Person[pid].d~=id2 then
War.Person[pid].d=id2
PlayWavE(6)
WarDelay(n*2)
end
end
elseif kind==1 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
WarAction(0,id2,d2)
elseif kind==2 then
elseif kind==3 then
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
PlayWavE(7)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==4 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(35)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==5 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
ReFresh()
end
lib.GetKey()
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].action=3
PlayWavE(30)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==6 then
WarAction(1,id1,id2)
War.Person[pid].action=2
War.Person[eid].action=2
for i=0,3 do
War.Person[pid].frame=i
War.Person[eid].frame=i
if i==3 then
PlayWavE(30)
WarDelay(n)
end
WarDelay(n)
end
WarDelay(n*2)
elseif kind==7 then
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
WarDelay(1)
end
War.Person[pid].effect=0
end
if i==3 then
PlayWavE(7)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==8 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
--War.Person[pid].d=d1
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
WarDelay(1)
end
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(36)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==9 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
lib.GetKey()
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
WarDelay(1)
end
lib.GetKey()
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].action=3
War.Person[eid].effect=256
PlayWavE(31)
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
lib.GetKey()
elseif kind==10 then
WarAction(1,id1,id2)
War.Person[pid].action=2
War.Person[eid].action=2
for i=0,3 do
War.Person[pid].frame=i
War.Person[eid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
War.Person[eid].effect=t
WarDelay(1)
end
lib.GetKey()
War.Person[pid].effect=0
War.Person[eid].effect=0
end
if i==3 then
War.Person[pid].effect=192
War.Person[eid].effect=192
PlayWavE(31)
WarDelay(n)
end
WarDelay(n)
end
War.Person[pid].effect=0
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==11 then
elseif kind==12 then
elseif kind==13 then
elseif kind==14 then
elseif kind==15 then
War.Person[pid].action=3
War.Person[pid].frame=0
WarDelay(n*2)
elseif kind==16 then
War.Person[pid].action=0
War.Person[pid].frame=0
WarDelay(n)
War.Person[pid].d=1
PlayWavE(6)
WarDelay(n*2)
War.Person[pid].action=3
War.Person[pid].frame=0
WarDelay(n*2)
PlayWavE(17)
for t=0,-256,-8 do
War.Person[pid].effect=t
WarDelay(1)
end
WarDelay(n*2)
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*4)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==17 then
War.Person[pid].action=5
WarDelay(n)
for i=1,5 do
War.Person[pid].frame=0
if War.Person[pid].action==9 then
War.Person[pid].action=5
PlayWavE(16)
else
War.Person[pid].action=9
end
WarDelay(n)
end
War.Person[pid].frame=-1
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*2)
WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["����"].."�����ˣ�",M_White)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==18 then
War.Person[pid].frame=0
War.Person[pid].action=5
for i=1,6 do
if War.Person[pid].action==9 then
War.Person[pid].action=5
else
War.Person[pid].action=9
end
WarDelay(n-1)
lib.GetKey()
end
for i=1,16 do
if War.Person[pid].action==9 then
War.Person[pid].action=5
else
War.Person[pid].action=9
end
WarDelay(n-2)
lib.GetKey()
end
PlayWavE(22)
War.Person[pid].action=5
for i=128,256,12 do
War.Person[pid].effect=i
WarDelay(n)
end
WarDelay(n*2)
War.Person[pid].frame=-1
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*4)
WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["����"].."�����ˣ�",M_White)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==19 then
War.Person[pid].action=5
War.Person[pid].frame=0
for i=0,5 do
War.Person[pid].frame=1-War.Person[pid].frame
WarDelay(n*2)
end
WarDelay(n*2)
end
WarResetStatus(pid)
WarResetStatus(eid)
War.ControlEnable=controlstatus
end

-- WarLastWords(wid)
-- ս����������
function WarLastWords(wid)
local wp=War.Person[wid]
local name=JY.Person[wp.id]["����"]
if true then--not wp.enemy then
if type(CC.LastWords[name])=='string' then
if wp.id==1 then
PlayBGM(4)
end
if CC.zdby==0 or wp.id==1 then
talk( wp.id,CC.LastWords[name])
end
end
end
end

-- ս�����ﱩ��̨��
function WarAtkWords(wid)
local wp=War.Person[wid]
local name=JY.Person[wp.id]["����"]
if CC.zdby==0 then--not wp.enemy then
if type(CC.AtkWords[name])=='string' then
talk( wp.id,CC.AtkWords[name])
else
local str={
"��ม�����", "������������", "ѽ����������", "�ȡ�����", "���ม�����",
"ɱ����������", "���а�������", "����һ�ǣ���", "ɱ������", "ȥ���ɣ�����",
"ࡺǡ�����", "ѽ߾������", "�����š�����", "����������", "������������",
"���ţ���", "�ߣ���", "�����ţ�", "���ᣡ��", "��ѽ����",
"��������������", "����������", "׼�����аɣ���", "׼�������ɣ�", "�ţ���"
}
local n=math.random(40)
if type(str[n])=='string' then
talk( wp.id,str[n])
end
end
end
end

-- ���ڸ����ж���ʹս�����ﶯ���ظ�Ĭ��״̬
function WarResetStatus(wid)
if between(wid,1,War.PersonNum) then
local v=War.Person[wid]
v.frame=-1
if v.live then
local id=v.id
if JY.Person[id]["����"]<=0 then
if v.action~=9 then
v.action=5
WarDelay(4)
JY.Death=id
DoEvent(JY.EventID)
JY.Death=0
if v.action~=9 then
WarLastWords(wid)
if id==1 then
WarAction(18,id)
else
WarAction(17,id)
end
end
end
elseif v.troubled then
v.action=7
elseif JY.Person[id]["����"]/JY.Person[id]["������"]<=0.30 then
v.action=5
elseif v.active then
v.action=1
else
v.action=0
end
if v.ai==6 then
if v.x==v.ai_dx and v.y==v.ai_dy then
v.ai=4
end
end
if CC.Enhancement then
ReSetAttrib(id,false) 
end
end
end
ReSetAllBuff()
end

--��þ���ֵ
function WarAddExp(id,Exp)
if Exp<=0 then
return
end
local pid=War.Person[id].id
if JY.Person[pid]["�ȼ�"]>=99 then
return
end
local oldExp=JY.Person[pid]["����"]
local lvupflag=false
local Exp2=0
if oldExp+Exp>100 then
Exp2=oldExp+Exp-100
Exp=Exp-Exp2
end
for i=0,Exp do
JY.Person[pid]["����"]=oldExp+i
for t=1,1 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id,true)
lib.GetKey()
ReFresh()
end
if JY.Person[pid]["����"]==100 then
lvupflag=true
WarLvUp(id)
JY.Person[pid]["����"]=0
oldExp=0
end
end
if Exp2>0 then
for i=0,Exp2 do
JY.Person[pid]["����"]=0+i
for t=1,1 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id,true)
lib.GetKey()
ReFresh()
end
end
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*3)
WarDelay(4)
if lvupflag then
JY.Person[pid]["����"]=oldExp+Exp2
else
JY.Person[pid]["����"]=oldExp+Exp
end
end

function WarAddExp2(id,Exp)--�����Լ��������������κ���ʾ
end

function WarLvUp(id)--�������Լ�����
if id==0 then
return
end
War.SelID=id
BoxBack()
local pid=War.Person[id].id
War.Person[id].action=0
for t=1,2 do
War.Person[id].d=3
WarDelay(3)
War.Person[id].d=2
WarDelay(3)
War.Person[id].d=4
WarDelay(3)
War.Person[id].d=1
WarDelay(3)
end
PlayWavE(11)
War.Person[id].action=6
WarDelay(16)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�ĵȼ������ˣ�",M_White)
local magic={}
for mid=1,JY.MagicNum-1 do
magic[mid]=false
if WarHaveMagic(id,mid) then
magic[mid]=true
end
end
JY.Person[pid]["�ȼ�"]=limitX(JY.Person[pid]["�ȼ�"]+1,1,99)
ReSetAttrib(pid,false)
WarResetStatus(id)
WarDelay(4)
--��ʾ���ܲ���ϰ��
if CC.Enhancement==true then
for i=1,6 do
if JY.Person[pid]["�ȼ�"]==CC.SkillExp[JY.Person[pid]["�ɳ�"]][i] then
PlayWavE(11)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."ϰ�ü���"..JY.Skill[JY.Person[pid]["�ؼ�"..i]]["����"].."��",M_White)
break
end
end
end
local str=""
for mid=1,JY.MagicNum-1 do
if not magic[mid] then
if WarHaveMagic(id,mid) then
if str=="" then
str=JY.Magic[mid]["����"]
else
str=str.."��"..JY.Magic[mid]["����"]
end
end
end
end
if #str>0 then
PlayWavE(11)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."ϰ�ò���"..str.."��",M_White)
end
War.LastID=War.SelID
War.SelID=0
end

function WarBingZhongUp(id,bzid)--���ֱ��������
if id==0 then
return
end
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local pid=War.Person[id].id
local oldaction=War.Person[id].action
--ʹ����Ʒ����
War.Person[id].action=0
War.Person[id].d=1
WarDelay(2)
PlayWavE(41)
War.Person[id].action=6
WarDelay(16)
--תȦ����������
War.Person[id].action=0
for t=1,2 do
War.Person[id].d=3
WarDelay(3)
War.Person[id].d=2
WarDelay(3)
War.Person[id].d=4
WarDelay(3)
War.Person[id].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[id].action=6
for i=0,256,8 do
War.Person[id].effect=i
WarDelay(1)
end
JY.Person[pid]["����"]=bzid
War.Person[id].bz=bzid
War.Person[id].movewav=JY.Bingzhong[bzid]["��Ч"]--�ƶ���Ч
War.Person[id].atkwav=JY.Bingzhong[bzid]["������Ч"]--������Ч
War.Person[id].movestep=JY.Bingzhong[bzid]["�ƶ�"]--�ƶ���Χ
War.Person[id].movespeed=JY.Bingzhong[bzid]["�ƶ��ٶ�"]--�ƶ��ٶ�
War.Person[id].atkfw=JY.Bingzhong[bzid]["������Χ"]--������Χ
War.Person[id].pic=WarGetPic(id)
for i=240,0,-8 do
War.Person[id].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�ı��ֳ�Ϊ"..JY.Bingzhong[bzid]["����"].."�ˣ�",M_White)
ReSetAttrib(pid,false)
War.Person[id].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[pid]["����"..n]==0 then
JY.Person[pid]["����"..n]=173
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."�õ�һö������",M_White)
break
end
end
end

function limitX(x,minv,maxv)--����x�ķ�Χ
if x<minv then
x=minv
elseif x>maxv then
x=maxv
end
return x
end
function SetWarConst()
War.DX={[0]="ƽԭ","ɭ��","ɽ��","����","����",
"��ǽ","�ǳ�","��ԭ","��ׯ","����",
"����","�ĵ�","դ��","¹��","��Ӫ",
"����","�����","����","����","����"}
-- 00 ƽԭ 01 ɭ�� 02 ɽ�� 03 ���� 04 ���� 05 ��ǽ 06 �ǳ� 07 ��ԭ
-- 08 ��ׯ 09 ���� 0A ���� 0B �ĵ� 0C դ�� 0D ¹�� 0E ��Ӫ 0F ����
-- 10 ����� 11 ���� 12 ���� 13 ����
War.Width=64--��ͼ�ߴ�
War.Depth=64
War.MW=12--old game 13
War.MD=9--old game 11
War.BoxWidth=48--��ͼ����ߴ�
War.BoxDepth=48
War.CX=1--���ϽǷ���λ��
War.CY=1
War.MX=1--��������λ��
War.MY=1
War.OldX=0--��¼�����ƶ�ǰ����
War.OldY=0
War.InMap=false--�������Ƿ��ڵ�ͼ��Χ��
War.OldMX=-1--��¼MXMYfor ������ �ƶ�������
War.OldMY=-1
War.DXpic=0--��¼��ǰ����ͼƬ
War.FrameT=0
War.Frame=0
War.MoveScreenFrame=0
War.ControlStatus="select"
War.PersonNum=0
War.Weather=math.random(6)-1
War.Turn=1--��ǰ�غ�
War.MaxTurn=30--���غ�
War.Leader1=-1
War.Leader2=-1
War.CurID=0
War.SelID=0
War.LastID=0--����CurID�����ƶ���������ʱ��������һ������ID
War.EnemyNum=0
War.FunButtom=0--��ǰ�����ڵİ�ť
War.ControlEnableOld=true
War.ControlEnable=true
War.YD=0
end

-- ��ʾս����ͼ
function DrawWarMap()
local x,y=War.CX,War.CY
lib.FillColor(0,0,0,0,0)
local x0,y0=x,y
local cx,cy=16,32
x0=limitX(x0,0,War.Width)
y0=limitX(y0,0,War.Depth)
local xoff=x-math.modf(x)
local yoff=y-math.modf(y)
lib.SetClip(cx,cy,cx+War.BoxWidth*War.MW,cy+War.BoxDepth*War.MD)
lib.PicLoadCache(0,War.MapID*2,cx-War.BoxWidth*(x-1),cy-War.BoxDepth*(y-1),1)
lib.SetClip(0,0,0,0)
for i=x,x+War.MW-1 do
for j=y,y+War.MD-1 do
local v=GetWarMap(i,j,1)
if v==18 then
lib.PicLoadCache(4,(250+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1)
elseif v==19 then
lib.PicLoadCache(4,(252+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1)
end
end
end
for x=War.CX,math.min(War.CX+War.MW,War.Width) do
for y=War.CY,math.min(War.CY+War.MD,War.Depth) do
if GetWarMap(x,y,4)==0 then--�����ƶ�
lib.Background(cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),cx+War.BoxWidth*(x-War.CX+1),cy+War.BoxDepth*(y-War.CY+1),128)
end
if GetWarMap(x,y,10)==1 then--������Χ
lib.PicLoadCache(4,261*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
elseif GetWarMap(x,y,10)==2 then--���Ʒ�Χ
lib.PicLoadCache(4,262*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
end
end
end
if War.InMap then
DrawGameBox(cx+War.BoxWidth*(War.MX-War.CX),cy+War.BoxDepth*(War.MY-War.CY),cx+War.BoxWidth*(War.MX-War.CX+1),cy+War.BoxDepth*(War.MY-War.CY+1),M_White,-1)
end
local size=48
local size2=64
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if between(v.x,x,x+War.MW-1) and between(v.y,y,y+War.MD-1) then--limit XY
local frame
if v.frame>=0 then
frame=v.frame
else
frame=War.Frame
end
local left=cx+War.BoxWidth*(v.x-x)
local top=cy+War.BoxDepth*(v.y-y)
--0��ֹ 1�ƶ� 2���� 3���� 4������ 5���� 7���� 9������
--v.action=7 ���Ի���ͼƬ��
if v.action==0 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1)
if not v.active then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+4,128)
end
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2,256+v.effect)
end
elseif v.action==1 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2,256+v.effect)
end
elseif v.action==2 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1)
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2+8,v.effect) 
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2,256+v.effect) 
end
elseif v.action==3 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1)
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2,256+v.effect)
end
elseif v.action==4 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2,256+v.effect)
end
elseif v.action==5 then
if v.effect==0 then
if v.active then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1)
else
lib.PicLoadCache(1,(v.pic+20)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+20)*2,left,top,1+2+4,128)
end
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2,256+v.effect)
end
elseif v.action==6 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2,256+v.effect)
end
elseif v.action==7 then--����
local hlpic=5010
if v.enemy then
hlpic=5012
elseif v.friend then
hlpic=5014
else
hlpic=5010
end
lib.PicLoadCache(1,(hlpic+frame%2)*2,left,top,1)
end
if v.hurt>=0 then
DrawString(left+size/2-#(v.hurt.."")*5,top,v.hurt,M_White,20)
end
end
end
end
if War.InMap then
if War.CY>1 and between(War.MX-War.CX,1,War.MW-2) and War.MY==War.CY then
lib.PicLoadCache(4,240*2,16+War.BoxWidth*(War.MX-War.CX)+13,32+War.BoxDepth*(War.MY-War.CY)+12,1)
elseif War.CY<War.Depth-War.MD+1 and between(War.MX-War.CX,1,War.MW-2) and War.MY==War.CY+War.MD-1 then
lib.PicLoadCache(4,244*2,16+War.BoxWidth*(War.MX-War.CX)+13,32+War.BoxDepth*(War.MY-War.CY)+12,1)
elseif War.CX>1 and between(War.MY-War.CY,1,War.MD-2) and War.MX==War.CX then
lib.PicLoadCache(4,246*2,16+War.BoxWidth*(War.MX-War.CX)+12,32+War.BoxDepth*(War.MY-War.CY)+13,1)
elseif War.CX<War.Width-War.MW+1 and between(War.MY-War.CY,1,War.MD-2) and War.MX==War.CX+War.MW-1 then
lib.PicLoadCache(4,242*2,16+War.BoxWidth*(War.MX-War.CX)+12,32+War.BoxDepth*(War.MY-War.CY)+13,1)
end
end
if War.ControlStatus=="select" then
if War.ControlEnable and War.CurID>0 then
DrawStatusMini(War.CurID)
end
elseif War.ControlStatus=="selectAtk" then
if War.ControlEnable then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then
DrawStatusMini(eid)
end
end
elseif War.ControlStatus=="checkDX" then
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(War.MX-War.CX)-136
else
menux=16+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=32+War.BoxWidth*(War.MY-War.CY)
end
lib.Background(menux,menuy,menux+136,menuy+86,160)
menux=menux+8
menuy=menuy+8
lib.LoadSur(War.DXpic,menux,menuy)
DrawString(menux+56,menuy+8,"����Ч��",M_White,16)
local T={[0]="����","������","������","����","����","����","����","����",
"����","����","����","����","����","������","������","����",
"����","����","����","����",}
DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],M_White,16)
--ɭ�� 20 ɽ�� 30 ��ׯ 5
--��ԭ 5 ¹կ 30 ��Ӫ 10
-- 00 ƽԭ 01 ɭ�� 02 ɽ�� 03 ���� 04 ���� 05 ��ǽ 06 �ǳ� 07 ��ԭ
-- 08 ��ׯ 09 ���� 0A ���� 0B �ĵ� 0C դ�� 0D ¹�� 0E ��Ӫ 0F ����
-- 10 ����� 11 ���� 12 ���� 13 ����
DrawString(menux,menuy+56,War.DX[dx],M_White,16)
if dx==8 or dx==13 or dx==14 then
DrawString(menux+56,menuy+56,"�лָ�",M_White,16)
end
--��ׯ��¹�ο��Իָ�ʿ���ͱ�������Ӫ���Իָ������������ָܻ�ʿ����
--�������Իָ�������ʿ����Ԯ��������Իָ���������������Իָ�ʿ����
--���κͱ���Ļָ��������ܵ��ӣ�Ҳ����˵�����ڴ�ׯ�������ٳ��лָ��Ա����û�г��лָ��Ա���Ч����ͬ�����������ֻ�ָܻ����������Ӫ������������Իָ���������������£�����ʿ�����ܵõ��Զ��ָ���
end
if CC.Enhancement then
lib.PicLoadCache(4,205*2,0,0,1)
else
lib.PicLoadCache(4,205*2,0,0,1)
end
DrawString(381-#War.WarName*16/2/2,8,War.WarName,M_White,16)
if War.Weather<3 then--��
lib.PicLoadCache(4,190*2,724,35,1)
elseif War.Weather>3 then--��
lib.PicLoadCache(4,192*2,724,35,1)
else--��
lib.PicLoadCache(4,191*2,724,35,1)
end
if War.ControlStatus=="select" then
if War.FunButtom==1 then
lib.PicLoadCache(4,57*2,15,7,1)
end
end
DrawStatus()
lib.PicLoadCache(0,200+War.MapID*2,War.MiniMapCX,War.MiniMapCY,1)
for i=1,War.Width do
for j=1,War.Depth do
if GetWarMap(i,j,9)~=0 then
local x=War.MiniMapCX+(i-1)*4
local y=War.MiniMapCY+(j-1)*4
lib.FillColor(x,y,x+4,y+4,M_DarkOrchid)
end
end
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
local color=M_Blue
if v.enemy then
color=M_Red
elseif v.friend then
color=M_DarkOrange
end
local x=War.MiniMapCX+(v.x-1)*4
local y=War.MiniMapCY+(v.y-1)*4
lib.FillColor(x,y,x+4,y+4,color)
end
end
lib.DrawRect(War.MiniMapCX+(War.CX-1)*4,War.MiniMapCY+(War.CY-1)*4,War.MiniMapCX+(War.CX+War.MW-1)*4,War.MiniMapCY+(War.CY+War.MD-1)*4,M_Yellow)
for i=1,JY.MenuPic.num do
lib.LoadSur(JY.MenuPic.pic[i],JY.MenuPic.x[i],JY.MenuPic.y[i])
end
War.FrameT=War.FrameT+1
if War.FrameT>=32 then
War.FrameT=0
end
War.Frame=math.modf(War.FrameT/8)
end

function DrawStatusMini(id,flag)
flag=flag or false
local pid=War.Person[id].id
local x,y=War.Person[id].x,War.Person[id].y
local bz=JY.Person[pid]["����"]
local menux,menuy
if x-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(x-War.CX)-180
else
menux=16+War.BoxWidth*(x-War.CX+1)
end
if y-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(y-War.CY)-32
else
menuy=32+War.BoxWidth*(y-War.CY)
end
lib.Background(menux,menuy,menux+180,menuy+80,160)
menux=menux+2
menuy=menuy+2
local color=M_Cyan
local str="�Ҿ�"
if War.Person[id].enemy then
color=M_Red
str="�о�"
elseif War.Person[id].friend then
color=M_DarkOrange
str="�Ѿ�"
end
if War.Person[id].troubled then
end
DrawString(menux,menuy,JY.Person[pid]["����"],color,16)
DrawString(menux+64,menuy,JY.Bingzhong[bz]["����"].."��Lv"..JY.Person[pid]["�ȼ�"],M_White,16)
local len=120
local T={
100*JY.Person[pid]["����"]/JY.Person[pid]["������"],
math.min(100*JY.Person[pid]["ʿ��"]/100,100),
100*JY.Person[pid]["����"]/100,
}
local n=2
if flag then
n=3
end
for i=1,n do
local color
if T[i]<30 then
color=210
elseif T[i]<70 then
color=211
else
color=212
end
lib.FillColor(menux+48,menuy+4+i*20,menux+48+len,menuy+4+10+i*20,M_Black)
local xd=menux+48+len*T[i]/100
if xd>menux+48 then
lib.SetClip(menux+48,menuy+4+i*20,xd,menuy+4+10+i*20)
lib.PicLoadCache(4,color*2,menux+48,menuy+4+i*20,1)
end
lib.SetClip(0,0,0,0)
end
menuy=menuy+20
DrawString(menux,menuy,string.format("�������� %4d/%d",JY.Person[pid]["����"],JY.Person[pid]["������"]),M_White,16)
menuy=menuy+20
DrawString(menux,menuy,string.format("ʿ������ %4d/100",JY.Person[pid]["ʿ��"]),M_White,16)
menuy=menuy+20
if flag then
DrawString(menux,menuy,string.format("���顡�� %4d/100",JY.Person[pid]["����"]),M_White,16)
else
local T={[0]="","��������","��������","","","","","������",
"������","","","","","��������","��������","",
"","","","",}
local dx=GetWarMap(x,y,1)
DrawString(menux,menuy,string.format("%s",str,War),color,16)
DrawString(menux+64,menuy,string.format("%s %s",War.DX[dx],T[dx]),M_White,16)
end
end

--�ɷ��
function DrawStatus()
local id
if War.SelID>0 then
id=War.SelID
elseif War.CurID>0 then
id=War.CurID
elseif War.LastID>0 then
id=War.LastID
else
return
end
local pid=War.Person[id].id
local p=JY.Person[pid]
local x=805
local y=140
local size=16
local len=100
local T={
{"�� ��","ʿ��ֵ","������","������","����ֵ","����ֵ"},
{100*p["����"]/p["������"],p["ʿ��"],math.min(p["����"]/20,100),math.min(p["����"]/20,100),100*p["����"]/p["������"],p["����"]},
{p["����"].."/"..p["������"],""..p["ʿ��"],""..p["����"],""..p["����"],p["����"].."/"..p["������"],""..p["����"]},
}
local x_off=x-785
DrawString(785+x_off,78,p["����"].."��"..JY.Bingzhong[p["����"]]["����"],M_White,size)
DrawString(900+x_off,78,"�ȼ�"..p["�ȼ�"],M_White,size)
DrawString(820+x_off,105,p["����"],M_White,size)
DrawString(875+x_off,105,p["����"],M_White,size)
DrawString(930+x_off,105,p["ͳ��"],M_White,size)
for i=1,6 do
DrawString(x,y,T[1][i],M_White,size)
local color
if T[2][i]<30 then
color=210
elseif T[2][i]<70 then
color=211
else
color=212
end
lib.FillColor(x+64,y+3,x+64+len,y+3+10,M_Black)
lib.SetClip(x+64,y+3,x+64+len*T[2][i]/100,y+3+10)
lib.PicLoadCache(4,color*2,x+64,y+3,1)
lib.SetClip(0,0,0,0)
DrawString(x+64+len/2-size*#T[3][i]/4,y,T[3][i],M_White,size)
y=y+size+12
end
end

--�·��
function DrawStatus()
local id
if War.SelID>0 then
id=War.SelID
elseif War.CurID>0 then
id=War.CurID
elseif War.LastID>0 then
id=War.LastID
else
return
end
local wp=War.Person[id]
local pid=War.Person[id].id
local p=JY.Person[pid]
local x=801-48*4
local y=190
local size=16
local len=90
local T={
{"�� ��","ʿ��ֵ","������","������","����ֵ","����ֵ"},
{math.min(100*p["����"]/p["������"],100),math.min(p["ʿ��"],100),math.min(p["����"]/20,100),math.min(p["����"]/20,100),math.min(100*p["����"]/math.max(p["������"],1),100),p["����"]},
{p["����"].."/"..p["������"],""..p["ʿ��"],""..p["����"],""..p["����"],p["����"].."/"..p["������"],""..p["����"]},
}
local x_off=x-785
lib.PicLoadCache(4,230*2,800-48*4,73,1)
lib.PicLoadCache(2,p["ͷ�����"]*2,808-48*4,81,1)
lib.PicLoadCache(4,227*2,884-48*4,79,1)
lib.PicLoadCache(4,228*2,884-48*4,109,1)
lib.PicLoadCache(4,229*2,884-48*4,139,1)
DrawString(x,y-size-3,p["����"].."��"..JY.Bingzhong[p["����"]]["����"].."Lv"..p["�ȼ�"],M_White,size)
for i,v in pairs({"����2","����2","ͳ��2"}) do
local zbdy=54
if not War.Person[id].enemy then
zbdy=46
end
if CC.Enhancement==false then
zbdy=54
end
DrawString2(916-48*4,zbdy+i*30,string.format("%d",p[v]),M_White,size)
end
if CC.Enhancement then
if not War.Person[id].enemy then
local wljy=p["��������"]
if p["����"]==100 then wljy=200 end
local str=string.format("%d",math.modf(wljy/2)).."��"
if wljy==200 then str="MAX"end DrawString2(916-49*4,60+30,str,M_White,16)
local zljy=p["��������"]
if p["����"]==100 then zljy=200 end
str=string.format("%d",math.modf(zljy/2)).."��"
if zljy==200 then str="MAX"end DrawString2(916-49*4,60+60,str,M_White,16)
local tljy=p["ͳ�ʾ���"]
if p["ͳ��"]==100 then tljy=200 end
str=string.format("%d",math.modf(tljy/2)).."��"
if tljy==200 then str="MAX"end DrawString2(916-49*4,60+90,str,M_White,16)
end
end
for i=1,6 do
DrawString(x,y,T[1][i],M_White,size)
local color
if T[2][i]<30 then
color=210
elseif T[2][i]<70 then
color=211
else
color=212
end
lib.FillColor(x+52,y+3,x+52+len,y+3+10,M_Black)
if T[2][i]>1 then
lib.SetClip(x+52,y+3,x+52+len*T[2][i]/100,y+3+10)
lib.PicLoadCache(4,color*2,x+52,y+3,1)
end
lib.SetClip(0,0,0,0)
DrawString2(x+52+len/2-size*#T[3][i]/4,y,T[3][i],M_White,size)
y=y+size+2
end
local leader=0
local forcename=""
leader=p["����"]--Ĭ�Ͼ����Լ��ľ���
if leader==0 then--��û���趨ʱ
if wp.enemy then--���� ���õ�����˧�ľ���
leader=JY.Person[War.Leader2]["����"]
end
end
if leader>0 then
forcename=JY.Person[leader]["����"]
else
if wp.enemy then
forcename="�о�"
elseif wp.friend then
forcename="�Ѿ�"
else
forcename="�Ҿ�"
end
end
DrawString(632-#forcename*16/2/2,40,forcename,M_White,16)
if CC.Enhancement then
DrawString(x,y,"����",M_White,size)
DrawSkillTable(pid,x+34,y)
y=y+42
DrawString(x,y,string.format("�� %+03d�� �� %+03d��",wp.atk_buff,wp.def_buff),M_White,size)
y=y+20
end
if CC.AIXS then
x=300
y=CC.ScreenH-size
if wp.ai==0 then
DrawString(x,y,"AI: ��������",M_White,size)
elseif wp.ai==1 then
DrawString(x,y,"AI: ��������",M_White,size)
elseif wp.ai==2 then
DrawString(x,y,"AI: ����ԭ��",M_White,size)
elseif wp.ai==3 then
DrawString(x,y,"AI: ���� "..JY.Person[wp.aitarget]["����"],M_White,size)
elseif wp.ai==4 then
DrawString(x,y,"AI: ���� "..wp.ai_dx..","..wp.ai_dy,M_White,size)
elseif wp.ai==5 then
DrawString(x,y,"AI: ���� "..JY.Person[wp.aitarget]["����"],M_White,size)
elseif wp.ai==6 then
DrawString(x,y,"AI: ���� "..wp.ai_dx..","..wp.ai_dy,M_White,size)
else
DrawString(x,y,"AI: ���� "..wp.aitarget.." "..wp.ai_dx..","..wp.ai_dy,M_White,size)
end
end
end

function DrawSkillTable(pid,x,y,flag)
flag=flag or 0
local p=JY.Person[pid]
local cx,cy
local box_w=36
local box_h=20
for i=1,6 do
local cx=x+box_w*((i-1)%3)
local cy=y+box_h*math.modf((i-1)/3)
lib.DrawRect(cx,cy,cx+box_w,cy,M_White)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_White)
lib.DrawRect(cx,cy,cx,cy+box_h,M_White)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_White)
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,240,M_Blue)
if p["�ȼ�"]>=CC.SkillExp[p["�ɳ�"]][i] or flag==2 then
DrawString(cx+2,cy+2,JY.Skill[p["�ؼ�"..i]]["����"],M_White,16)
else
DrawString(cx+2,cy+2,"����",M_Gray,16)
end
end
end

function CleanWarMap(lv,v)
for x=1,War.Width do
for y=1,War.Depth do
SetWarMap(x,y,lv,v)
end
end
end

function GetWarMap(x,y,lv)
if x>0 and x<=War.Width and y>0 and y<=War.Depth then
if lv==1 then
if War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==1 then
return 18
elseif War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==2 then
return 19
else
return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]
end
else
return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]
end
else
lib.Debug(string.format("error!GetWarMapx=%d,y=%d,width=%d,depth=%d",x,y,War.Width,War.Depth))
return 0
end
end

function SetWarMap(x,y,lv,v)
if x>0 and x<=War.Width and y>0 and y<=War.Depth then
War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]=v
return 1
else
lib.Debug(string.format("error!SetWarMapx=%d,y=%d,v=%d,width=%d,depth=%d",x,y,v,War.Width,War.Depth))
return 0
end
end

function filelength(filename)--�õ��ļ�����
local inp=io.open(filename,"rb")
if inp==nil then
return -1
end
local l=inp:seek("end")
inp:close()
return l
end

function LoadWarMap(id)
local len=filelength(CC.MapFile)
local data=Byte.create(len)
Byte.loadfile(data,CC.MapFile,0,len)
local map_num=58
local idx1,idx2,idx3,idx4=Byte.get8(data,16+256+12*id+8),Byte.get8(data,16+256+12*id+9),Byte.get8(data,16+256+12*id+10),Byte.get8(data,16+256+12*id+11)
if idx1<0 then
idx1=idx1+256
end
if idx2<0 then
idx2=idx2+256
end
if idx3<0 then
idx3=idx3+256
end
if idx4<0 then
idx4=idx4+256
end
local idx=idx4+256*idx3+256^2*idx2+256^3*idx1
War.Width=Byte.get8(data,idx)/2
War.Depth=Byte.get8(data,idx+1)/2
War.MiniMapCX=680-War.Width*2
War.MiniMapCY=411-War.Depth*2
War.Map={}
CleanWarMap(1,0)--����
CleanWarMap(2,0)--wid
CleanWarMap(3,0)--
CleanWarMap(4,1)--ѡ��Χ
CleanWarMap(5,-1)--������ֵ
CleanWarMap(6,-1)--���Լ�ֵ
CleanWarMap(7,0)--ѡ��Ĳ���
CleanWarMap(8,0)--AIǿ���ã��Ҿ��Ĺ�����Χ
CleanWarMap(9,0)--ˮ�����
CleanWarMap(10,0)--������Χ����ʾ��
 idx=idx+2+4*War.Width*War.Depth
for i=1,War.Width*War.Depth do
local v=Byte.get8(data,idx+(i-1))
if v<0 or v>19 then
lib.Debug(string.format("!!Error, MapID=%d,idx=%d,v=%d",id,i,v))
v=0
end
War.Map[i]=v--Byte.get8(data,idx+(i-1))
end
end

-- WarSearchMove(id,x,y)
-- Ѱ���ƶ���x,y�����·��
-- flag,Ϊtrueʱ���ӵ�����·
function WarSearchMove(id,x,y,flag)
flag=flag or false
local stepmax=256
CleanWarMap(4,0)--��4���������������ƶ����ȶ���Ϊ0
local steparray={}--�����鱣���n�������꣮
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--���ݵ�0���������ҳ���1����Ȼ�������
WarSearchMove_sub(steparray,i,id,flag)
if steparray[i+1].num==0 then
break
end
end
return
end

function WarSearchMove_sub(steparray,step,id,flag)--������һ�����ƶ�������
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["����"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--��ǰ���������ڸ�
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["����"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
if CheckZOC(id,nx,ny) then
steparray[step1].m[num]=steparray[step].m[i]-elyd-JY.Bingzhong[bz]["�ƶ�"]
else
steparray[step1].m[num]=steparray[step].m[i]-elyd
end
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
end
end
end
end
end
steparray[step1].num=num
end

-- WarSearchBZ(id)
-- Ѱ������ҷ�ָ������
function WarSearchBZ(id,bzid)
local stepmax=256
CleanWarMap(4,0)--��4���������������ƶ����ȶ���Ϊ0��
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--�����鱣���n�������꣮
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--���ݵ�0���������ҳ���1����Ȼ�������
local eid=WarSearchBZ_sub(steparray,i,id,bzid,true)
if eid>0 then
return eid
end
if steparray[i+1].num==0 then
break
end
end
return 0
end

function WarSearchBZ_sub(steparray,step,id,bzid,flag)--������һ�����ƶ�������
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["����"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--��ǰ���������ڸ�
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["����"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
 steparray[step1].x[num]=nx
 steparray[step1].y[num]=ny
 steparray[step1].m[num]=steparray[step].m[i]-elyd
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy==War.Person[eid].enemy then
-- ���� ���� �Ƿ��� 
if bzid==War.Person[eid].bz and JY.Person[War.Person[eid].id]["����"]>=6 then
return eid
end
end
end
end
end
end
end
steparray[step1].num=num
return 0
end

-- WarSearchEnemy(id)
-- Ѱ���������
function WarSearchEnemy(id)
local stepmax=256
CleanWarMap(4,0)--��4���������������ƶ����ȶ���Ϊ0��
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--�����鱣���n�������꣮
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
local eidbk=0
for i=0,stepmax-1 do--���ݵ�0���������ҳ���1����Ȼ�������
local eid=WarSearchEnemy_sub(steparray,i,id,true)
if eid>0 then
return eid
end
if eidbk==0 and eid<0 then
eidbk=-eid
end
if steparray[i+1].num==0 then
break
end
end
return eidbk
end

function WarSearchEnemy_sub(steparray,step,id,flag)--������һ�����ƶ�������
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["����"]
local eidbk=0
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--��ǰ���������ڸ�
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["����"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
steparray[step1].m[num]=steparray[step].m[i]-elyd
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
-- ���� ���� �Ƿ��� ���� 
--���Ѿ���Ѱ������������ڿ��Թ���������
local array=WarGetAtkFW(nx,ny,War.Person[id].atkfw)
for n=1,array.num do
if between(array[n][1],1,War.Width) and between(array[n][2],1,War.Depth) then
if GetWarMap(array[n][1],array[n][2],4)>0 and GetWarMap(array[n][1],array[n][2],2)==0 then
return eid
end
end
end
eidbk=-eid
end
end
end
end
end
end
steparray[step1].num=num
return 0
end

-- War_CalAtkFW(wid)
-- ��ʾwid�Ĺ�����Χ
function War_CalAtkFW(wid)
local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,War.Person[wid].atkfw)
for i=1,array.num do
local mx,my=array[i][1],array[i][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
SetWarMap(mx,my,10,1)
end
end
end

--������ƶ�����
--id ս����id��
--stepmax �������
--flag=0 �ƶ�����Ʒ�����ƹ���1 �书���ö�ҽ�Ƶȣ������ǵ�·��
function War_CalMoveStep(id,stepmax,flag)--������ƶ�����
CleanWarMap(4,0)--��4���������������ƶ����ȶ���Ϊ0��
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--�����鱣���n�������꣮
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end

SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--���ݵ�0���������ҳ���1����Ȼ�������
War_FindNextStep(steparray,i,id,flag)
if steparray[i+1].num==0 then
break
end
end
return steparray
end

function War_FindNextStep(steparray,step,id,flag)--������һ�����ƶ�������
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["����"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--��ǰ���������ڸ�
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["����"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
if (not flag) and CheckZOC(id,nx,ny) then
steparray[step1].m[num]=0
else
steparray[step1].m[num]=steparray[step].m[i]-elyd
end
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
end
end
end
end
end
steparray[step1].num=num
end

function CheckZOC(id,x,y)
if CC.Enhancement then
if WarCheckSkill(id,34) then--ǿ��
return false
end
end
for d=1,4 do--��ǰ���������ڸ�
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
return true
end
end
end
return false
end

function War_CanMoveXY(x,y,pid,flag)--�����Ƿ����ͨ�����ж��ƶ�ʱʹ��
local id1=War.Person[pid].id
local bz=JY.Person[id1]["����"]
local dx=GetWarMap(x,y,1)
if JY.Bingzhong[bz]["����"..dx]==0 then
return false
end
local eid=GetWarMap(x,y,2)
if eid>0 and (not flag) and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[pid].enemy~=War.Person[eid].enemy then
return false
end
return true
end

function WarCanExistXY(x,y,pid)--�����Ƿ����ͨ��
local id1=War.Person[pid].id
local bz=JY.Person[id1]["����"]
local dx=GetWarMap(x,y,1)
if JY.Bingzhong[bz]["����"..dx]==0 then
return false
end
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
return false
end
return true
end

function War_MovePerson(x,y,flag)--�ƶ����ﵽλ��x,y
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
flag=flag or 0
local movenum=GetWarMap(x,y,4)
local dx,dy=x,y
local movetable={}-- ��¼ÿ���ƶ�
local mx,my=War.Person[War.SelID].x,War.Person[War.SelID].y
local dm=GetWarMap(mx,my,4)
local start=dm
local str=JY.Person[War.Person[War.SelID].id]["����"]..'���ƶ�'
for i=1,dm do
if mx==x and my==y then
start=i-1
break
end
movetable[i]={}
movetable[i].x=x
movetable[i].y=y
local fx,fy
for d=1,4 do
local nx,ny=x-CC.DirectX[d],y-CC.DirectY[d]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
local v=GetWarMap(nx,ny,4)
if v>movenum then
movenum=v
fx,fy=nx,ny
movetable[i].direct=d
end
end
end
x,y=fx,fy
end
--8�Ǳ�׼�ٶȣ�6ƫ�죬4�ܿ�,3���죬12��,16
local step=War.Person[War.SelID].movespeed
if CC.MoveSpeed==1 then
step=1
end
SetWarMap(War.Person[War.SelID].x,War.Person[War.SelID].y,2,0)
SetWarMap(dx,dy,2,War.SelID)
War.ControlEnable=false
War.InMap=false
War.Person[War.SelID].action=1
local sframe=0
for i=start,1,-1 do
War.Person[War.SelID].d=movetable[i].direct
local cx=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]
local cy=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]
if War.SelID>0 then
if not between(War.CX,cx-War.MW+1,cx-1) then
War.CX=limitX(War.CX,cx-War.MW+3,cx-3)
War.CX=limitX(War.CX,1,War.Width-War.MW+1)
end
if not between(War.CY,cy-War.MD+1,cy-1) then
War.CY=limitX(War.CY,cy-War.MD+2,cy-2)
War.CY=limitX(War.CY,1,War.Depth-War.MD+1)
end
end
for t=1,step do
War.Person[War.SelID].x=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]/step
War.Person[War.SelID].y=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]/step
lib.GetKey(1)
War.Person[War.SelID].frame=math.modf(sframe/4)%2
if sframe==0 then
PlayWavE(War.Person[War.SelID].movewav)
end
if sframe==7 then
sframe=0
else
sframe=sframe+1
end
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[War.SelID].x=cx
War.Person[War.SelID].y=cy
end
if War.Person[War.SelID].active then
War.Person[War.SelID].action=1
else
War.Person[War.SelID].action=0
end
War.Person[War.SelID].frame=-1
War.Person[War.SelID].x=dx
War.Person[War.SelID].y=dy
BoxBack()
local pid=War.Person[War.SelID].id
ReSetAttrib(pid,false)
ReSetAllBuff()
War.CurID=0
War.ControlEnable=War.ControlEnableOld
end

function ReSetAttrib(id,flag)
local p=JY.Person[id]
local wid=GetWarID(id)
if wid>0 then
War.Person[wid].sq_limited=100
else
p["ʿ��"]=100
end
if CC.Enhancement then
if CheckSkill(id,7) then--����
if wid>0 then
War.Person[wid].sq_limited=JY.Skill[7]["����1"]
else
p["ʿ��"]=JY.Skill[7]["����1"]
end
end
end
if wid>0 and flag then
p["ʿ��"]=War.Person[wid].sq_limited
end
if CC.Enhancement and wid>0 then
if CheckSkill(id,31) then--����
if p["ʿ��"]<JY.Skill[31]["����1"] then
p["ʿ��"]=math.min(War.Person[wid].sq_limited,JY.Skill[31]["����1"])
end
end
end
local bid=p["����"]
local b=JY.Bingzhong[bid]
p["������"]=b["��������"]+b["��������"]*(p["�ȼ�"]-1)
if CC.Enhancement then
if CheckSkill(id,6) then--��ʦ
p["������"]=b["��������"]+JY.Skill[6]["����1"]+(b["��������"]+JY.Skill[6]["����2"])*(p["�ȼ�"]-1)
end
end
if wid>0 and CC.Enhancement then
if CheckSkill(id,45) then--����
War.Person[wid].atkfw=JY.Skill[45]["����1"]
end
end
--Get Weapon
local weapon1=0
local weapon2=0
local weapon3=0
for i=1,8 do
local item=p["����"..i]
if item>0 then
local canuse=false
if JY.Item[item]["�����1"]==0 then
canuse=true
else
for n=1,7 do
if JY.Item[item]["�����"..n]==p["����"] then
canuse=true
break
end
end
end
if p["�ȼ�"]<JY.Item[item]["��ȼ�"] then
canuse=false
end
if canuse then
if JY.Item[item]["װ��λ"]==1 then
if weapon1==0 or JY.Item[item]["���ȼ�"]>JY.Item[weapon1]["���ȼ�"] then
weapon1=item
end
elseif JY.Item[item]["װ��λ"]==2 then
if weapon2==0 or JY.Item[item]["���ȼ�"]>JY.Item[weapon2]["���ȼ�"] then
weapon2=item
end
elseif JY.Item[item]["װ��λ"]==3 then
if weapon3==0 or JY.Item[item]["���ȼ�"]>JY.Item[weapon3]["���ȼ�"] then
weapon3=item
end
end
end
end
end
p["����"]=weapon1
p["����"]=weapon2
p["����"]=weapon3
--���������ӳɺ������
local p_wuli=p["����"]
local p_tongshuai=p["ͳ��"]
local p_zhili=p["����"]
local atk,def,mov=0,0,0
mov=b["�ƶ�"]
if weapon1>0 then
p_wuli=p_wuli+JY.Item[weapon1]["����"]
p_zhili=p_zhili+JY.Item[weapon1]["����"]
p_tongshuai=p_tongshuai+JY.Item[weapon1]["ͳ��"]
atk=atk+JY.Item[weapon1]["����"]
def=def+JY.Item[weapon1]["����"]
mov=mov+JY.Item[weapon1]["�ƶ�"]
end
if weapon2>0 then
p_wuli=p_wuli+JY.Item[weapon2]["����"]
p_zhili=p_zhili+JY.Item[weapon2]["����"]
p_tongshuai=p_tongshuai+JY.Item[weapon2]["ͳ��"]
atk=atk+JY.Item[weapon2]["����"]
def=def+JY.Item[weapon2]["����"]
mov=mov+JY.Item[weapon2]["�ƶ�"]
end
if weapon3>0 then
p_wuli=p_wuli+JY.Item[weapon3]["����"]
p_zhili=p_zhili+JY.Item[weapon3]["����"]
p_tongshuai=p_tongshuai+JY.Item[weapon3]["ͳ��"]
atk=atk+JY.Item[weapon3]["����"]
def=def+JY.Item[weapon3]["����"]
mov=mov+JY.Item[weapon3]["�ƶ�"]
end
p["����2"]=p_wuli
p["����2"]=p_zhili
p["ͳ��2"]=p_tongshuai
p["������"]=math.modf(p_zhili*(p["�ȼ�"]+10)/40)+b["���Գɳ�"]*p["�ȼ�"]
p["����"]=limitX(p["����"],0,p["������"])
--����4000�£�140�������������ֻ�����������2��ʿ���������ȼ���10����10������100�����﹥���ӳɣ���100
p["����"]=math.modf(((4000/math.max(140-p_wuli,30))*(p["�ȼ�"]+10)/10+(b["����"]+p["ʿ��"])*(p["�ȼ�"]+10)/10)*(100+atk)/100)
p["����"]=math.modf(((4000/math.max(140-p_tongshuai,30))*(p["�ȼ�"]+10)/10+(b["����"]+p["ʿ��"])*(p["�ȼ�"]+10)/10)*(100+def)/100)
if CC.Enhancement then
if CheckSkill(id,30) then--��˫
p["����"]=p["����"]+JY.Skill[30]["����1"]*p["�ȼ�"]
p["����"]=p["����"]+JY.Skill[30]["����1"]*p["�ȼ�"]
else--����˫���򲻿�������ͼ���
if CheckSkill(id,8) then--����
p["����"]=p["����"]+JY.Skill[8]["����1"]*p["�ȼ�"]
end
if CheckSkill(id,9) then--����
p["����"]=p["����"]+JY.Skill[9]["����1"]*p["�ȼ�"]
end
end
if JY.Bingzhong[p["����"]]["Զ��"]>0 and CheckSkill(id,24) then--ǿ��
p["����"]=p["����"]+JY.Skill[24]["����1"]*p["�ȼ�"]
p["����"]=p["����"]+JY.Skill[24]["����1"]*p["�ȼ�"]
end
if JY.Bingzhong[p["����"]]["����"]>0 and CheckSkill(id,25) then--ǿ��
p["����"]=p["����"]+JY.Skill[25]["����1"]*p["�ȼ�"]
p["����"]=p["����"]+JY.Skill[25]["����1"]*p["�ȼ�"]
end
if CheckSkill(id,10) then--�ٹ�
mov=mov+JY.Skill[10]["����1"]
end
end
p["�ƶ�"]=mov
if wid>0 then
War.Person[wid].movestep=mov
end
if flag then
p["����"]=p["������"]
p["����"]=p["������"]
else
p["����"]=limitX(p["����"],0,p["������"])
end
--Buff
if wid>0 then
ReSetBuff(wid)
end
end

function ReSetAllBuff()
for wid,wp in pairs(War.Person) do
if wp.live and (not wp.hide) then
ReSetBuff(wid)
end
end
end

function ReSetBuff(wid)
if wid>0 and CC.Enhancement then
local pid=War.Person[wid].id
local p=JY.Person[pid]
War.Person[wid].atk_buff=0
War.Person[wid].def_buff=0
--����
local T={[0]=0,20,30,0,0,--ɭ�֡�20��ɽ�ء�30
0,0,5,5,0,--��ׯ�� 5 ��ԭ�� 5
0,0,0,30,10,--¹կ��30����Ӫ��10
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0}
local dx=GetWarMap(War.Person[wid].x,War.Person[wid].y,1)
War.Person[wid].def_buff=War.Person[wid].def_buff+T[dx]
--��ˮ
if WarCheckSkill(wid,28) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[28]["����2"]*math.modf(100*(p["������"]-p["����"])/p["������"]/JY.Skill[28]["����1"])
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[28]["����2"]*math.modf(100*(p["������"]-p["����"])/p["������"]/JY.Skill[28]["����1"])
else
--����
if WarCheckSkill(wid,27) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[27]["����2"]*math.modf(100*(p["������"]-p["����"])/p["������"]/JY.Skill[27]["����1"])
end
--����
if WarCheckSkill(wid,26) then
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[26]["����2"]*math.modf(100*(p["������"]-p["����"])/p["������"]/JY.Skill[26]["����1"])
end
end
 
--����
if War.Person[wid].was_hide then
if WarCheckSkill(wid,21) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[21]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[21]["����1"]
end
end
--����
if WarCheckSkill(wid,29) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff-JY.Skill[29]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[29]["����2"]
end
--��ս
if WarCheckSkill(wid,32) then
-- 00 ƽԭ 01 ɭ�� 02 ɽ�� 03 ���� 04 ���� 05 ��ǽ 06 �ǳ� 07 ��ԭ
-- 08 ��ׯ 09 ���� 0A ���� 0B �ĵ� 0C դ�� 0D ¹�� 0E ��Ӫ 0F ����
-- 10 ����� 11 ���� 12 ���� 13 ����
if dx==6 or dx==13 or dx==14 then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[32]["����1"]
end
end
--����
if WarCheckSkill(wid,49) then
local value=0
local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,2)
for i=1,4 do
local eid=GetWarMap(array[i][1],array[i][2],2)
if eid>0 then
if War.Person[wid].enemy~=War.Person[eid].enemy then
value=value+JY.Skill[49]["����1"]
end
end
end
for i=5,8 do
local eid=GetWarMap(array[i][1],array[i][2],2)
if eid>0 then
if War.Person[wid].enemy~=War.Person[eid].enemy then
value=value+JY.Skill[49]["����2"]
end
end
end
War.Person[wid].atk_buff=War.Person[wid].atk_buff+value
War.Person[wid].def_buff=War.Person[wid].def_buff+value
end
--������
local bz_flag=true
--[[
--����
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["����1"]
end
else
if CheckSkill(War.Leader1,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["����1"]
end
end
end
if bz_flag then
if WarCheckSkill(wid,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["����1"]
end
end
--κ��
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["����1"]
end
else
if CheckSkill(War.Leader1,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["����1"]
end
end
end
if bz_flag then
if WarCheckSkill(wid,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["����1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["����1"]
end
end
]]--
--����
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["����1"]
end
else
if CheckSkill(War.Leader1,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["����1"]
end
end
end
if bz_flag then
if CC.Enhancement and WarCheckSkill(wid,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["����1"]
end
end
War.Person[wid].atk_buff=limitX(War.Person[wid].atk_buff,-50,95)
War.Person[wid].def_buff=limitX(War.Person[wid].def_buff,-50,95)
end
end

--�ж�˳����ж����Զ������������Ϊ׼��
--�������ж����Ǵ��ڻָ��Ե��Σ���ׯ����Ӫ��¹�Σ��еĲ��ӣ�������ֻ���Ӵ��ڻָ��Ե����ϣ�����������Ļ���Ϸ��ĵо��б��е�˳�����У�
--�ڶ������ж����Ǳ���С����������40����ʿ������40�Ĳ��ӣ�������ֻ���Ŵ��ڸ������£�����������Ļ���Ϸ��ĵо��б��е�˳��������У�
--������µĲ��Ӱ���Ļ���Ϸ��ĵо��б��е�˳��������У�
function AI()
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
--�Ѿ�
local flag=true
--�������ж���
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (dx==8 or dx==13 or dx==14) then
War.ControlEnable=false
War.InMap=false
if flag then
--�Ѿ�״��
WarDrawStrBoxDelay('�Ѿ�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
--�ڶ������ж���
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (JY.Person[v.id]["����"]/JY.Person[v.id]["������"]<=0.4 or JY.Person[v.id]["ʿ��"]<=40) then
War.ControlEnable=false
War.InMap=false
if flag then
--�Ѿ�״��
WarDrawStrBoxDelay('�Ѿ�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
--���µĲ���
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active then
War.ControlEnable=false
War.InMap=false
if flag then
--�Ѿ�״��
WarDrawStrBoxDelay('�Ѿ�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
--�о�
WarGetAramyAtkFW()
flag=true
--�������ж���
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (v.bz==13 or v.bz==19) then
War.ControlEnable=false
War.InMap=false
if flag then
--�о�״��
WarDrawStrBoxDelay('�о�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (dx==8 or dx==13 or dx==14) then
War.ControlEnable=false
War.InMap=false
if flag then
--�о�״��
WarDrawStrBoxDelay('�о�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
--�ڶ������ж���
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (JY.Person[v.id]["����"]/JY.Person[v.id]["������"]<=0.4 or JY.Person[v.id]["ʿ��"]<=40) then
War.ControlEnable=false
War.InMap=false
if flag then
--�о�״��
WarDrawStrBoxDelay('�о�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
--���µĲ���
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active then
War.ControlEnable=false
War.InMap=false
if flag then
--�о�״��
WarDrawStrBoxDelay('�о�״��',M_White)
flag=false
end
AI_Sub(i)
end
end
War.ControlEnable=War.ControlEnableOld
end

function WarGetAramyAtkFW()
CleanWarMap(8,0)
for i,v in pairs(War.Person) do
if not v.enemy then
if not v.hide then
if v.live then
local len=1
if v.atkfw==2 or v.atkfw==3 then
len=2
elseif v.atkfw==4 then
len=3
elseif v.atkfw==5 then
len=4
end
CleanWarMap(5,-1)
local steparray=War_CalMoveStep(i,v.movestep+len)
for j=0,v.movestep+len do
for k=1,steparray[j].num do
local mx,my=steparray[j].x[k],steparray[j].y[k]
SetWarMap(mx,my,8,GetWarMap(mx,my,8)+1)
end
end
end
end
end
end
CleanWarMap(5,-1)
end

function WarGetAramyAtkFW()
CleanWarMap(8,0)
for i,v in pairs(War.Person) do
if not v.enemy then
if not v.hide then
if v.live then
local array=WarGetAtkFW(v.x,v.y,2)
for j=1,array.num do
local mx,my=array[j][1],array[j][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
local n=2
if j>4 then
n=1
end
local ov=GetWarMap(mx,my,8)
if n>ov then
SetWarMap(mx,my,8,n)
end
end
end
end
end
end
end
end

function AI_Sub(id,flag)
--AI���ͣ�00 ���������ͣ�������ԭ�ز��ƶ���������е��˽������ƶ����ܹ������ĵط������ӽ��ƶ������й�����
--AI���ͣ�01 ���������ͣ����ӻ������ƶ�������
--AI���ͣ�02 ����ԭ���ͣ�������ԭ�ز��ƶ�����ʹ�ܵ�����Ҳ����ˣ���������˽����乥����Χ�����ӽ����𹥻���
--AI���ͣ�03 ׷��ָ��Ŀ��
--AI���ͣ�04 �ƶ���Ŀ�ģ�����
--AI���ͣ�05 ��Ŀ���޹����ƶ�
--AI���ͣ�06 �ƶ���ĳ�㲻����
--[[
00=(X,Y) �ƶ�/n �ƶ���
���ƶ���Χ+������Χ�����Ҿ���ѡ���ж���ֵ��ߵĶ���������
1�������˴���Ϊn=FFʱ������(X,Y)�����ƶ���
2�������˴���Ϊn=FFʱ���ҵ�����(X,Y)���꣬��AI��Ϊ03=(X,Y) ������
3�������˴���Ϊn=00~2C�ҳ��˻��ڳ�ʱ������ս��n�������ƶ���
4�������˴���Ϊn=00~2C�ҳ�����ʧ����AI��Ϊ01=��������С�

01=��������У�
���ƶ���Χ+������Χ�����Ҿ���ѡ���ж���ֵ��ߵĶ�����������������Ҿ��ƶ���

02=(X,Y) ����/n ������
���۹�����Χ���Ƿ����Ҿ�����ѡ���ж���ֵ��ߵĶ��������ǲ����ƶ���
X,Y,n�������塣����ȷ����

03=(X,Y) ����/n ������
���ƶ���Χ+������Χ�����Ҿ���ѡ���ж���ֵ��ߵĶ��������򲻻��ƶ���
X,Y,n�������塣����ȷ����

04=(X,Y) �޹����ƶ�/n �޹����ƶ���
ֻ�ᳯ��Ŀ������(X,Y)�ƶ��������˴���ΪFF����ս��n�������ƶ������ṥ����ʹ�ò��ԡ�
1�������˴���Ϊn=FFʱ���ҵ�����(X,Y)���꣬��AI��Ϊ03=(X,Y) ������
2�������˴���Ϊn=00~2C�ҳ�����ʧ����AI��Ϊ01=��������С�

07=����
���ҷ�AI��07����Ϊ�Ѿ���
]]-- 
WarPersonCenter(id)
--���� ��Ѱ�ƶ���Χ�ڣ��й������ƶ���������û�пɹ����ģ��Ϳ����ƶ�
local did=0
War.SelID=id
local wp=War.Person[id]
local id1=wp.id
--XXX���ƶ�
CleanWarMap(5,-1)
CleanWarMap(6,-1)
CleanWarMap(7,-1)
local dx,dy=wp.x,wp.y
local dv=0
if JY.Base["�о�����"]==1 then
if wp.ai==0 or wp.ai==2 then
if not wp.friend then
wp.ai=1
end
end
end
local ccai=0
if flag~=nil then
ccai=wp.ai
wp.ai=2
end
--AI����ʵ������Զ�����
--AI���ͣ�03 ׷��ָ��Ŀ�� ��׷��Ŀ����ʧʱ--����������
if wp.ai==3 then
local eid=GetWarID(wp.aitarget)
if not (eid>0 and War.Person[eid].live) then
 wp.ai=1
end
end
if wp.ai~=2 then--���� ����ԭ���� ���⣬������ai���Ͷ���Ҫ�����ƶ�
local steparray=War_CalMoveStep(id,wp.movestep)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
if GetWarMap(mx,my,2)==0 or (mx==wp.x and my==wp.y) then
local v=WarGetMoveValue(id,mx,my)
if v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
--������ӵı������㣨������С����������40����ʿ��С��40����ͬ����
if dv<50 then
if JY.Person[id1]["����"]/JY.Person[id1]["������"]<=0.4 then
local eid=WarSearchBZ(id,19)
if eid>0 then
did=eid
 dv=0
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif JY.Person[id1]["ʿ��"]<=40 then
local eid=WarSearchBZ(id,13)
if eid>0 then
did=eid
dv=0
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
end
end
if dv>0 then--�ƶ���Χ��Ŀ��
if dx~=wp.x or dy~=wp.y then--��Ҫ�ƶ�
War_CalMoveStep(id,wp.movestep)
BoxBack()
War_MovePerson(dx,dy)
War.ControlEnable=false
War.InMap=false
end
else--һ���ƶ���Χ����Ŀ��
if wp.ai==1 then--�����ƶ����������
local eid=WarSearchEnemy(id)
if eid>0 then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
v=v-ddv
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif wp.ai==3 or wp.ai==5 then
local eid=GetWarID(wp.aitarget)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
if GetWarMap(wp.x,wp.y,4)==0 then
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y,true)--����Ҳ���·���������ӵ�����·������һ��
end
if GetWarMap(wp.x,wp.y,4)==0 then
eid=WarSearchEnemy(id)
if eid>0 then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)--����Ҳ���·�������ƶ����������
end
end
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
v=v-ddv
end
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif wp.ai==4 or wp.ai==6 then
WarSearchMove(id,wp.ai_dx,wp.ai_dy)
if GetWarMap(wp.x,wp.y,4)==0 then
WarSearchMove(id,wp.ai_dx,wp.ai_dy,true)--����Ҳ���·���������ӵ�����·������һ��
end
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-wp.ai_dx),math.abs(my-wp.ai_dy))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
v=v-ddv
end
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
if dx~=wp.x or dy~=wp.y then
War_CalMoveStep(id,wp.movestep)
BoxBack()
War_MovePerson(dx,dy)
War.ControlEnable=false
War.InMap=false
end
end
end
CleanWarMap(4,1)
--XXX�Ĺ���
local eid=0
dv=0
if wp.ai==5 or wp.ai==6 then
else
local atkarray=WarGetAtkFW(dx,dy,War.Person[id].atkfw)
for i=1,atkarray.num do
if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
local v=WarGetAtkValue(id,atkarray[i][1],atkarray[i][2])
if v>dv then
dv=v
eid=GetWarMap(atkarray[i][1],atkarray[i][2],2)
end
end
end
local mv,magicx,magicy=WarGetMagicValue(id,dx,dy)
if mv>0 then
--����ϵ���ӣ������������ֵ����100����Ϊ0��new��
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
if dv<100 then
dv=0
end
end
end
if mv>dv and flag==nil then
local mid=GetWarMap(magicx,magicy,7)
eid=GetWarMap(magicx,magicy,2)
did=eid
BoxBack()
WarDrawStrBoxDelay(string.format("%sʹ��%s�ƣ�",JY.Person[id1]["����"],JY.Magic[mid]["����"]),M_White)
WarMagic(id,eid,mid)
if CC.Enhancement and WarCheckSkill(id,119) then
if (JY.Magic[mid]["����"]==1 or JY.Magic[mid]["����"]==2 or JY.Magic[mid]["����"]==3) and JY.Magic[mid]["Ч����Χ"]==11 then
WarMagic(id,eid,mid)
end
end
if CC.Enhancement and WarCheckSkill(id,112) then--���ǽ� ����ֵ���ļ���
JY.Person[id1]["����"]=JY.Person[id1]["����"]-math.modf(JY.Magic[mid]["����"]/2)
else
JY.Person[id1]["����"]=JY.Person[id1]["����"]-JY.Magic[mid]["����"]
end
JY.Person[id1]["����"]=limitX(JY.Person[id1]["����"],0,JY.Person[id1]["������"])
else
if eid>0 then
did=eid
BoxBack()
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["����"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["�ɷ���"]==1 and JY.Bingzhong[War.Person[id].bz]["������"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,42) then--����(�ؼ�)
xsgj=true
end
end
end
end
if xsgj then
--����Ƿ��ڹ�����Χ��
xsgj=false
local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,xs_arrary.num do
if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==id then
xsgj=true
break
end
end
end
end

if xsgj then
--�������ʣ��Ҿ��佫������150
if CC.Enhancement and WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
WarAtk(eid,id,1)
WarResetStatus(id)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--����
if math.random(100)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
end
end
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(id,eid)
WarResetStatus(eid)
end
--���ҹ���
if CC.Enhancement and WarCheckSkill(id,116) then
if JY.Person[War.Person[eid].id]["����"]>0 then
War.Person[eid].troubled=true
War.Person[eid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["����"].."�����ˣ�",M_White)
end
end
--��������
local ydgj=0
if CC.Enhancement and WarCheckSkill(id,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(id,108) then
ydgj=1
end
if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["����"]<=0 then
War.YD=1
AI_Sub(id,1)
end
elseif ydgj==2 then
local yd=eid
while yd~=0 do
if JY.Person[War.Person[yd].id]["����"]<=0 then
yd=AI_Sub(id,1)
did=yd
else
break
end
end
end
if CC.Enhancement and WarCheckSkill(id,114) then--Ӣ��֮�� ���̹���
local mx=War.Person[id].x
local my=War.Person[id].y
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0
if dx>0 and dy==0 then--��ȷ�����������ڹ�������߷���
if GetWarMap(xx-1,yy,2)>0 then--Ȼ��ȷ���Ǳ������������һ��Ķ���
eid2=GetWarMap(xx-1,yy,2)--��ȡ��һ�������id���
if War.Person[eid].enemy==War.Person[eid2].enemy then--���ȷ���뱻������ͬ��Ӫ
WarAtk(id,eid2)--����
WarResetStatus(eid2)
end
end
end
if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then--��
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then--��
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then--��
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then--����
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then--����
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then--����
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then--����
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
end
--����
local fsfj=false--װ���������µ����˲��ǹ���ʱ��ɱ����
if CC.Enhancement and WarCheckSkill(id,105) then
fsfj=true
end
if JY.Person[War.Person[eid].id]["����"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
--ֻ��������ɽ�������������������������ܷ����о�����������
--����������Ϊ��������������ޱ��š������ҡ�������ʱ���ſ��ܲ���������
--����������Ϊ���������������ֶӡ�����ʦ�������ʱ�������ܷ���������
--������Ϊ��������ʱ�������Բ�������
local fj_flag=false
if JY.Bingzhong[War.Person[eid].bz]["�ɷ���"]==1 and JY.Bingzhong[War.Person[id].bz]["������"]==1 then
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,42) then--����(�ؼ�)
fj_flag=true
end
if fj_flag then
--����Ƿ��ڹ�����Χ��
fj_flag=false
local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,fj_arrary.num do
if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==id then
fj_flag=true
break
end
end
end
end
if fj_flag then
--�������ʣ��Ҿ��佫������150
if CC.Enhancement and WarCheckSkill(eid,102) then--����װ������˫�� ������ʱ�ض�����
WarAtk(eid,id,1)
WarResetStatus(id)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--����
if math.random(100)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["����2"] then
--�ɰ���ì
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end
if smsh==1 and smfj==1 then
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["����"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
end
end
end
end
end
War.ControlEnable=false
War.InMap=false
end
wp.active=false
wp.action=0
WarResetStatus(id)
WarCheckStatus()
War.LastID=War.SelID
War.SelID=0
WarDelay(CC.WarDelay)
War.YD=0
if flag~=nil then
wp.ai=ccai
end
return did
end

--������ӵı������㣨������С����������40����ʿ��С��40����ͬ������ս���ϴ��ڿɻָ����ε����꣬�ж���ֵ��50��
--����ֵ������������ɱ�ˣ���������ǰ������6
--���������ж���ֵ������ֵ��16��
--����������ǳ��ˣ�����ֵ������ֵ��30
--�����Ӵ����з����ӳɵĵ���ʱ���ж���ֵ���ж���ֵ�������ӳɡ�5
function WarGetMoveValue(pid,x,y)
local id1=War.Person[pid].id
local wp=War.Person[pid]
local atkarray=WarGetAtkFW(x,y,War.Person[pid].atkfw)
local dv=0
if wp.ai==5 or wp.ai==6 then
dv=0
else
for i=1,atkarray.num do
if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
local v=WarGetAtkValue(pid,atkarray[i][1],atkarray[i][2])
if v>0 then--Զ�๥�����⸽��
if i<=4 then
elseif i<=8 then
v=v+2
elseif i<=16 then
v=v+3
elseif i<=24 then
v=v+4
end
end
if v>dv then
dv=v
end
end
end
local mv=WarGetMagicValue(pid,x,y)
--����ϵ���ӣ������������ֵ����100����Ϊ0��new��
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
if dv<100 then
dv=0
end
end
if mv>dv then
dv=mv
end
end
local dx=GetWarMap(x,y,1)
if dv>0 then
--�����Ӵ����з����ӳɵĵ���ʱ���ж���ֵ���ж���ֵ�������ӳɡ�5--2.5
if dx==1 then--�ɻָ����� ����+5���Լ������ģ�
dv=dv+8
elseif dx==2 then
dv=dv+10
elseif dx==7 then
dv=dv+2
elseif dx==8 then
dv=dv+2+5
elseif dx==13 then
dv=dv+12+5
elseif dx==14 then
dv=dv+4+5
end
--����AI�ٸ���
if wp.ai==3 or wp.ai==5 then
local eid=GetWarID(wp.aitarget)
if eid>0 then
local tx,ty=War.Person[eid].x,War.Person[eid].y
dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y))
end
elseif wp.ai==4 or wp.ai==6 then
local tx,ty=wp.ai_dx,wp.ai_dy
dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y))
end
end
--������ӵı������㣨������С����������40����ʿ��С��40����ͬ������ս���ϴ��ڿɻָ����ε����꣬�ж���ֵ��50��
if JY.Person[id1]["����"]/JY.Person[id1]["������"]<=0.4 or JY.Person[id1]["ʿ��"]<=40 then
if dx==8 or dx==13 or dx==14 then
dv=dv+50
end
end
--�����ģ�mp����ʱ���������ֶ�
for d=1,4 do
local sid=0
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
sid=GetWarMap(nx,ny,2)
if sid>0 and sid~=pid then
if War.Person[sid].enemy==wp.enemy and War.Person[sid].bz==13 then
if JY.Person[id1]["����"]/JY.Person[id1]["������"]<=0.4 then
dv=dv+10
break
end
end
end
end
end
if wp.enemy then
local ddv=GetWarMap(x,y,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
dv=dv-ddv
end
end
return dv
end

function HaveMagic(pid,mid)
local bz=JY.Person[pid]["����"]
local lv=JY.Person[pid]["�ȼ�"]
if JY.Status~=GAME_WMAP then
if between(mid,1,36) then
if between(JY.Bingzhong[bz]["����"..mid],1,lv) then
return true
end
end
else
local eid=0
local eid2=0
local eid3=0
local eid4=0
local id=War.SelID
local mx=War.Person[id].x
local my=War.Person[id].y
if CC.Enhancement and WarCheckSkill(id,101) then--����ģ��
if GetWarMap(mx-1,my,2)>0 then--��
eid=GetWarMap(mx-1,my,2)
end
if GetWarMap(mx+1,my,2)>0 then--��
eid2=GetWarMap(mx+1,my,2)
end
if GetWarMap(mx,my-1,2)>0 then--��
eid3=GetWarMap(mx,my-1,2)
end
if GetWarMap(mx,my+1,2)>0 then--��
eid4=GetWarMap(mx,my+1,2)
end
end
if between(mid,1,36) then
if between(JY.Bingzhong[bz]["����"..mid],1,lv) then
return true
end
if eid>0 and between(JY.Bingzhong[JY.Person[eid]["����"]]["����"..mid],1,lv) then
return true
elseif eid2>0 and between(JY.Bingzhong[JY.Person[eid2]["����"]]["����"..mid],1,lv) then
return true
elseif eid3>0 and between(JY.Bingzhong[JY.Person[eid3]["����"]]["����"..mid],1,lv) then
return true
elseif eid4>0 and between(JY.Bingzhong[JY.Person[eid4]["����"]]["����"..mid],1,lv) then
return true
end
end
end
if CC.Enhancement then
if mid==37 then
if CheckSkill(pid,1) then
if lv>=JY.Skill[1]["����1"] then
return true
end
end
elseif mid==38 then
if CheckSkill(pid,1) then
if lv>=JY.Skill[1]["����2"] then
return true
end
end
elseif mid==39 then
if CheckSkill(pid,4) then
if lv>=JY.Skill[4]["����1"] then
return true
end
end
elseif mid==40 then
if CheckSkill(pid,3) then
if lv>=JY.Skill[3]["����1"] then
return true
end
end
elseif mid==41 then
if CheckSkill(pid,39) then
if lv>=JY.Skill[39]["����2"] then
return true
end
end
elseif mid==42 then
if CheckSkill(pid,39) then
if lv>=JY.Skill[39]["����3"] then
return true
end
end
elseif mid==43 then
if CheckSkill(pid,40) or CheckSkill(pid,5) then
if lv>=JY.Skill[40]["����1"] then
return true
end
end
elseif mid==44 then
if CheckSkill(pid,40) or CheckSkill(pid,5) then
if lv>=JY.Skill[40]["����2"] then
return true
end
end
elseif mid==46 then
if CheckSkill(pid,38) then
if lv>=JY.Skill[38]["����2"] then
return true
end
end
end
end
return false
end

function WarHaveMagic(wid,mid)
local pid=War.Person[wid].id
return HaveMagic(pid,mid)
end

function WarGetMagicValue(pid,x,y)
local dv=0
local dx,dy
local bz=War.Person[pid].bz
local id1=War.Person[pid].id
local lv=JY.Person[id1]["�ȼ�"]
local ox,oy=War.Person[pid].x,War.Person[pid].y
War.Person[pid].x,War.Person[pid].y=x,y
SetWarMap(ox,oy,2,0)
SetWarMap(x,y,2,pid)
for mid=1,JY.MagicNum-1 do
if WarHaveMagic(pid,mid) then
if JY.Person[id1]["����"]>=JY.Magic[mid]["����"] then--mp enough?
if true then--dx?
local kind=JY.Magic[mid]["����"]
local fw=JY.Magic[mid]["ʩչ��Χ"]
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local mx,my=array[j][1],array[j][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
local eid=GetWarMap(mx,my,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(pid,eid,mid) then--check dx
if ((between(kind,1,5) or between(kind,9,10)) and War.Person[pid].enemy~=War.Person[eid].enemy) or (between(kind,6,8) and War.Person[pid].enemy==War.Person[eid].enemy) then
local v,select_magic=WarGetMagicValue_sub(pid,mx,my)
if v>dv and mid==select_magic then
dv=v
dx,dy=mx,my
end
end
end
end
end
end
end
end
end
end
War.Person[pid].x,War.Person[pid].y=ox,oy
SetWarMap(x,y,2,0)
SetWarMap(ox,oy,2,pid)
return dv,dx,dy
end

function WarGetMagicValue_sub(pid,x,y)
local id1,id2
id1=War.Person[pid].id
local bz=War.Person[pid].bz
local lv=JY.Person[id1]["�ȼ�"]
local oid=GetWarMap(x,y,2)
local dv=GetWarMap(x,y,6)
local select_magic=GetWarMap(x,y,7)
local hp={600,1200,1800}
local sp={30,40,50}
if dv==-1 then
dv=0
local v=0
for mid=1,JY.MagicNum-1 do
if WarHaveMagic(pid,mid) then
if JY.Person[id1]["����"]>=JY.Magic[mid]["����"] then--mp enough?
if oid>0 and War.Person[oid].live and (not War.Person[oid].hide) then
if WarMagicCheck(pid,oid,mid) then--���Σ�����
local kind=JY.Magic[mid]["����"]
local power=JY.Magic[mid]["Ч��"]
local fw=JY.Magic[mid]["Ч����Χ"]
if between(kind,1,3) or between(kind,9,10) then--��ˮʯ/����
 v=0
if War.Person[pid].enemy~=War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy and WarMagicCheck(pid,eid,mid) then
local hurt=WarMagicHurt(pid,eid,mid)
if hurt>=JY.Person[War.Person[eid].id]["����"] then
hurt=hurt*10
end
if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
v=v+hurt
else
v=v+hurt/4
end
end
end
end
end
end
elseif kind==4 then--���鱨
v=0
--��������ѻ��ң���Ȩֵ��0
--���ֵ����0��299���������
--���ݼ��鱨ϵ����ȫ�����е��㷨��������Ƿ�ɹ�������������ǲ��Գɹ�����Ȩֵ���������300��
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and (not War.Person[eid].troubled) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
v=math.random(300)-1
if math.random()<WarMagicHitRatio(pid,eid,mid) then
v=v+300
end
end
end
elseif kind==5 then--ǣ��
v=0
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
id2=War.Person[eid].id
--����ֵ�����Ի���������ʹ���ߵȼ���10����ǣ���ߵȼ���10
--���ֵ��1��10�������
--��Ȩֵ������ֵ�������
v=power+lv/10-JY.Person[id2]["�ȼ�"]/10
v=limitX(v,0,JY.Person[id2]["ʿ��"])
local add=math.random(10)
v=math.modf(v*add)
end
end
end
elseif kind==6 then--����
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
--����ֵ�����Ի���������ʹ���ߵȼ���10
--���ֵ��0��������ֵ��10��1��֮��������
--����ֵ������ֵ�����ֵ
local sv=power+lv/10
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["ʿ��"])
if sv<10 then
sv=0
end
if JY.Person[id2]["ʿ��"]<40 then
sv=sv*20
end
v=v+sv
end
end
end
end
end
elseif kind==7 then--Ԯ��
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
--���Ի���������ʹ����������ʹ���ߵȼ���20
--���ֵ��0��������ֵ��10��1��֮��������
--����ֵ������ֵ�����ֵ
local sv=power+JY.Person[id1]["����2"]*lv/20
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,JY.Person[id2]["������"]-JY.Person[id2]["����"])
if sv<JY.Person[id2]["������"]/10 then
sv=0
end
v=v+sv
end
end
end
end
end
if v/JY.Magic[mid]["����"]<50 then
v=0
end
elseif kind==8 then--����
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
local sv=hp[power]+JY.Person[id1]["����2"]*lv/20
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,JY.Person[id2]["������"]-JY.Person[id2]["����"])
if sv<JY.Person[id2]["������"]/10 then
sv=0
end
v=v+sv
sv=sp[power]+lv/10
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["ʿ��"])
if sv<10 then
sv=0
end
if JY.Person[id2]["ʿ��"]<40 then
sv=sv*20
end
v=v+sv
if v<400 then
v=0
end
end
end
end
end
end
end
v=math.modf(v/(JY.Magic[mid]["����"]+12))
if v>dv then
dv=v
select_magic=mid
end
end
end
end
end
SetWarMap(x,y,6,dv)
SetWarMap(x,y,7,select_magic)
end
return dv,select_magic
end

function WarGetAtkValue(pid,x,y)
local id1,id2
id1=War.Person[pid].id
local bz=War.Person[pid].bz
local v=GetWarMap(x,y,5)
if v==-1 then
v=0
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
id2=War.Person[eid].id
v=WarAtkHurt(pid,eid,0)
if v>=JY.Person[id2]["����"] then--һ����ɱ���⸽��
v=v+1600
elseif JY.Person[id2]["����"]<JY.Person[id2]["������"]/2 then--�о�������ʱ����������
v=v+math.modf((JY.Person[id2]["������"]-JY.Person[id2]["����"])/6)
end
--�ж���ֵ������ֵ��16��
v=math.modf(v/16)
--����������ǳ��ˣ��ж���ֵ���ж���ֵ��30
if id2==War.Person[pid].aitarget then
v=v+30
end
--������������������ж���ֵ=�ж���ֵ+?
if War.Person[eid].leader then
v=v+16
end
end
end
SetWarMap(x,y,5,v)
end
return v
end

function WarGetAtkFW(x,y,fw)
local atkarray={}
if fw==1 then--�̱�
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
atkarray.num=4
elseif fw==2 then--����
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==3 then--����
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=8
elseif fw==4 then--���
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=16
elseif fw==5 then--�����
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
--4
table.insert(atkarray,{x+2,y+2})
table.insert(atkarray,{x+2,y-2})
table.insert(atkarray,{x-2,y+2})
table.insert(atkarray,{x-2,y-2})
table.insert(atkarray,{x,y+3})
table.insert(atkarray,{x,y-3})
table.insert(atkarray,{x+3,y})
table.insert(atkarray,{x-3,y})
atkarray.num=24
elseif fw==6 then--Ͷʯ��
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x,y+3})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x+3,y})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x,y-3})
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x-3,y})
table.insert(atkarray,{x-2,y+1})
table.insert(atkarray,{x-1,y-2})
--4
table.insert(atkarray,{x,y+4})
table.insert(atkarray,{x+1,y+3})
table.insert(atkarray,{x+2,y+2})
table.insert(atkarray,{x+3,y+1})
table.insert(atkarray,{x+4,y})
table.insert(atkarray,{x+3,y-1})
table.insert(atkarray,{x+2,y-2})
table.insert(atkarray,{x+1,y-3})
table.insert(atkarray,{x,y-4})
table.insert(atkarray,{x-1,y-3})
table.insert(atkarray,{x-2,y-2})
table.insert(atkarray,{x-3,y-1})
table.insert(atkarray,{x-4,y})
table.insert(atkarray,{x-3,y+1})
table.insert(atkarray,{x-2,y+2})
table.insert(atkarray,{x-1,y+3})
atkarray.num=36
elseif fw==7 then--ͻ���
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=12
elseif fw==8 then--����
for i=1,2 do
table.insert(atkarray,{x-i,y})
table.insert(atkarray,{x+i,y})
table.insert(atkarray,{x,y-i})
table.insert(atkarray,{x,y+i})
table.insert(atkarray,{x-i,y-i})
table.insert(atkarray,{x+i,y-i})
table.insert(atkarray,{x-i,y+i})
table.insert(atkarray,{x+i,y+i})
end
atkarray.num=16
elseif fw==11 then--ԭ��-- 11~20 ����ר��
table.insert(atkarray,{x,y})
atkarray.num=1
elseif fw==12 then--���
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
atkarray.num=5
elseif fw==13 then--�˸�
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==14 then--�Ÿ�
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=9
elseif fw==15 then--ʮ����
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=12
elseif fw==16 then--ʮ����
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=13
elseif fw==17 then--��ʮ��
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=20
elseif fw==18 then--��ʮһ��
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=21
elseif fw==19 then
atkarray.num=0
elseif fw==20 then
atkarray.num=0
elseif fw==21 then--ѡ���ҷ�������8��
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==22 then--ѡ���ҷ�������9��
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=9
else
atkarray.num=0
end
return atkarray
end

function WarSetAtkFW(id,fw)
local mx=War.Person[id].x
local my=War.Person[id].y
local atkarray=WarGetAtkFW(mx,my,fw)
CleanWarMap(4,0)
for i=1,atkarray.num do
if between(atkarray[i][1],1,War.Width) and between(atkarray[i][2],1,War.Depth) then
SetWarMap(atkarray[i][1],atkarray[i][2],4,1)
end
end
end

function CheckActive()
--�ҷ�ȫ���ж����?
if JY.Status~=GAME_WMAP then--����Ϸ״̬�ı�ʱ��ֱ�ӽ����ҷ�����
return true
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and v.active and (not v.troubled) then--����һ�˿��ж����򷵻�
return false
end
end
War.ControlStatus='DrawStrBoxYesorNo'
if WarDrawStrBoxYesNo("�������в��ӵ�������",M_White) then
return true
else
return false
end
end

function WarCheckStatus()
if JY.Status==GAME_WMAP then
--�з�ʧ�ܣ�
local enum=0
for i,v in pairs(War.Person) do
if v.enemy then
if v.live then--and (not v.hide) then
 enum=enum+1
end
end
if v.leader and (not v.live) then
if v.enemy then
JY.Status=GAME_WARWIN
break
else
JY.Status=GAME_WARLOSE
break
end
end
end
if enum==0 and JY.Status==GAME_WMAP then
JY.Status=GAME_WARWIN
end
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
War.ControlEnable=War.ControlEnableOld
end
end

--WarDelay(n)
-- ��ʱ����ˢ��ս��
-- nĬ��Ϊ1
function WarDelay(n)
 n=n or 1
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
lib.GetKey()
ReFresh()
end
end

function WarPersonCenter(id)
if id<1 or id>War.PersonNum then
return false
end
if War.Person[id].live==false then
return false
end
War.SelID=id
BoxBack()
--WarDelay(CC.WarDelay)
War.LastID=War.SelID
War.SelID=0
return true
end

function WarRest()
--���ﴦ�ڻָ��Ե��λ���лָ��Ա�����Դ����Զ��ָ���
--��ׯ��¹�ο��Իָ�ʿ���ͱ�������Ӫ���Իָ������������ָܻ�ʿ����
--�������Իָ�������ʿ����Ԯ��������Իָ���������������Իָ�ʿ����
--���κͱ���Ļָ��������ܵ���
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
local hp,sp=0,0
local hp_times=0
local sp_times=0
local hp_item_flag=false
local sp_item_flag=false
local hp_skill_flag=false
local sp_skill_flag=false
for index=1,8 do
local tid=JY.Person[v.id]["����"..index]
if JY.Item[tid]["����"]==7 then
if JY.Item[tid]["Ч��"]==1 then
hp_item_flag=true
elseif JY.Item[tid]["Ч��"]==2 then
sp_item_flag=true
elseif JY.Item[tid]["Ч��"]==3 then
hp_item_flag=true
sp_item_flag=true
end
end
end
if CC.Enhancement then
if WarCheckSkill(i,22) then--����
hp_skill_flag=true
end
end
local dx=GetWarMap(v.x,v.y,1)
--08 ��ׯ 0D ¹�� 0E ��Ӫ
if dx==8 or dx==13 then
hp_times=hp_times+1
sp_times=sp_times+1
elseif dx==14 then
hp_times=hp_times+1
end
if hp_item_flag then
hp_times=hp_times+1
end
if sp_item_flag then
sp_times=sp_times+1
end
if hp_skill_flag then
hp_times=hp_times+1
end
if sp_skill_flag then
sp_times=sp_times+1
end
if hp_times>0 then
--�������Զ��ָ�����150����0��10֮������������10
hp=150+(math.random(11)-1)*10
--�޸�Ϊ���������10%-20%
if CC.Enhancement then
hp=math.max(150+(math.random(11)-1)*10,math.modf(JY.Person[v.id]["������"]/1000*(math.modf(JY.Person[v.id]["ͳ��2"]/10)+1+math.random(10)))*10)
end
--�������ָ������������Ĳ�಻��10ʱ��ϵͳ���Զ������ò��
hp=hp*hp_times
if JY.Person[v.id]["������"]-JY.Person[v.id]["����"]-hp<9 then
hp=JY.Person[v.id]["������"]-JY.Person[v.id]["����"]
end
end
if sp_times>0 then
--ʿ�����Զ��ָ�����ͳ������10����1��5֮����������
sp=math.modf(JY.Person[v.id]["ͳ��2"]/10)+math.random(5)
--������ָ���£�ʿ���ָ��󳬹�90ʱ��ϵͳ���Զ�����ʿ��
sp=sp*sp_times
if v.sq_limited-JY.Person[v.id]["ʿ��"]-sp<9 then
sp=v.sq_limited-JY.Person[v.id]["ʿ��"]
end
end
if hp>0 or sp>0 then
War.MX=v.x
War.MY=v.y
War.CX=War.MX-math.modf(War.MW/2)
War.CY=War.MY-math.modf(War.MD/2)
War.CX=limitX(War.CX,1,War.Width-War.MW+1)
War.CY=limitX(War.CY,1,War.Depth-War.MD+1)
WarDelay(16)
local tmax=16
tmax=math.min(16,(math.modf(math.max(2,math.abs(hp)/50,math.abs(sp)))))
local oldbl=JY.Person[v.id]["����"]
local oldsq=JY.Person[v.id]["ʿ��"]
for t=0,tmax do
JY.ReFreshTime=lib.GetTime()
JY.Person[v.id]["����"]=oldbl+hp*t/tmax
JY.Person[v.id]["ʿ��"]=oldsq+sp*t/tmax
DrawWarMap()
DrawStatusMini(i)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
end
--����ֵ���Զ��ָ���
--����λ�ھ��ֶ��Ա߿����Զ��ָ�����ֵ���ָ�����ÿ���ֶӣ��ȼ���10���㣮
if v.bz==13 then
for d=1,4 do
local x,y=v.x+CC.DirectX[d],v.y+CC.DirectY[d]
if between(x,1,War.Width) and between(y,1,War.Depth) then
local eid=GetWarMap(x,y,2)
if eid>0 then
if (not War.Person[eid].hide) and War.Person[eid].live then
local pid=War.Person[eid].id
JY.Person[pid]["����"]=limitX(JY.Person[pid]["����"]+math.modf(1+JY.Person[v.id]["�ȼ�"]/10),0,JY.Person[pid]["������"])
end
end
end
end
end
if CC.Enhancement then
if WarCheckSkill(i,35) then--�ٳ�
JY.Person[v.id]["����"]=limitX(JY.Person[v.id]["����"]+math.modf(1+JY.Person[v.id]["�ȼ�"]*JY.Skill[35]["����1"]/100),0,JY.Person[v.id]["������"])
end
end
--�Զ����ѣ�
--ÿ�غ�ϵͳ����ͼ���ѻ����еĲ��ӣ������в��ӻָ�����״̬���㷨���£�
--�ָ����ӣ�0��99�������������ָ�����С�ڣ�ͳ������ʿ������3����ô���ӱ����ѣ��ɴ˿�����ͳ��Խ�ߣ�ʿ��Խ�ߣ�Խ���״ӻ��������ѣ�
--ע�⣺�Զ����ѵ��ж������Զ��ָ�����еģ�������Իָ����ʿ��Ϊ׼��
WarTroubleShooting(i)
WarResetStatus(i)
end
end
end

function ESCMenu()
PlayWavE(0)
local menu={
{"�غϽ���",nil,1},
{"ȫ��ί��",nil,1},
{"ȫ������",nil,1},
{"ʤ������",nil,1},
{"�����趨",nil,1},
{"������",nil,1},
{"������",nil,1},
{"��Ϸ����",nil,1},
{"��Debug ",nil,0},
}
local file=io.open(CONFIG.CurrentPath .. "Menu.debug")
if(file) then
menu[9][3]=1
end
local r=WarShowMenu(menu,#menu,0,64,64,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if r==1 then
return WarDrawStrBoxYesNo("�������в��ӵ�������",M_White)
elseif r==2 then
if WarDrawStrBoxYesNo("ί��ʣ�ಿ�ӱ��غϵ�������",M_White) then
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and (not v.friend) and v.active then
War.ControlEnable=false
War.InMap=false
AI_Sub(i)
end
end
return true
end
elseif r==3 then --ȫ������
WarIni2() --�����ǰս�������ео�
War.SelID=0--������ָ�������id
War.CurID=0--�����ǰ�ж���id
War.LastID=0--�����һ�������ָ�������id
NextEvent(JY.Base["ȫ������"])--����ִ�б���ս���¼�
return true
elseif r==4 then
WarShowTarget()--��ʾ����Ŀ��
elseif r==5 then
SettingMenu()--�����趨
elseif r==6 then--����
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."δʹ�õ���"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,136,"��ѡ������ĵ���",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="δʹ�õ���" then
if WarDrawStrBoxYesNo(string.format("������Ӳ���ĵ�%d���ȣ�������",s2),M_White) then
LoadRecord(s2)
end
else
WarDrawStrBoxConfirm("û������",M_White,true)
end
end
elseif r==7 then--����
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."δʹ�õ���"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,136,"���������������",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("������Ӳ���ĵ�%d�ţ�������",s2),M_White) then
WarSave(s2)
end
end
elseif r==8 then
if WarDrawStrBoxYesNo('������Ϸ��',M_White) then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo('����һ����',M_White) then
WarDelay(CC.WarDelay)
JY.Status=GAME_START
else
WarDelay(CC.WarDelay)
JY.Status=GAME_END
end
end
elseif r==9 then
local menu2={
{" AI�鿴",nil,1},
{"����鿴",nil,1},
{"�������",nil,1},
{"���ûغ�",nil,1},
{"����ȫ��",nil,1},
{"�����ж�",nil,1},
{"�ı�����",nil,1},
}
local s=WarShowMenu(menu2,#menu2,0,300,128,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if s==1 then--AI�鿴
if CC.AIXS==false then
CC.AIXS=true
WarDrawStrBoxWaitKey('����AI�ж�������ʾ��',M_White)
elseif CC.AIXS==true then
CC.AIXS=false
WarDrawStrBoxWaitKey('�ر�AI�ж�������ʾ��',M_White)
end
elseif s==2 then--����鿴
if CC.XYXS==false then
CC.XYXS=true
WarDrawStrBoxWaitKey('����������ʾ��',M_White)
elseif CC.XYXS==true then
CC.XYXS=false
WarDrawStrBoxWaitKey('�ر�������ʾ��',M_White)
end
elseif s==3 then--�������
if CC.RWTS==false then
CC.RWTS=true
WarDrawStrBoxWaitKey('����������ԣ�',M_White)
elseif CC.RWTS then
CC.RWTS=false
WarDrawStrBoxWaitKey('�ر�������ԣ�',M_White)
end
elseif s==4 then--�غ�����
local hhs={}
for hhxh=1,War.MaxTurn do
hhs[hhxh]={fillblank("��"..hhxh.."�غ�",11),nil,1}
end
local hh=ShowMenu(hhs,#hhs,8,0,0,0,0,6,1,16,M_White,M_White)
if hh>0 then
War.Turn=hh
WarDrawStrBoxWaitKey('�غ���������Ϊ'..hh,M_White)
end
elseif s==5 then--����ȫ��
if CC.KZAI==false then
CC.KZAI=true
WarDrawStrBoxWaitKey('�ɲٿ��Ѿ��͵о���',M_White)
elseif CC.KZAI==true then
CC.KZAI=false
WarDrawStrBoxWaitKey('�رղٿ��Ѿ��͵о����ܣ�',M_White)
end
elseif s==6 then--�����ж�
if CC.WXXD==false then
CC.WXXD=true
WarDrawStrBoxWaitKey('���������ж����ܣ�',M_White)
elseif CC.WXXD==true then
CC.WXXD=false
WarDrawStrBoxWaitKey('�ر������ж����ܣ�',M_White)
end
elseif s==7 then
local tqmenu={
{"�� ��",nil,1},
{"�� �",nil,1},
{"�� ��",nil,1},
}
local tq=ShowMenu(tqmenu,#tqmenu,0,0,0,0,0,1,1,16,M_White,M_White)
if tq==1 then
War.Weather=math.random(3)-1
WarDrawStrBoxWaitKey('���������죮',M_White)
elseif tq==2 then
War.Weather=3
WarDrawStrBoxWaitKey('���������죮',M_White)
elseif tq==3 then
War.Weather=math.random(2)+3
WarDrawStrBoxWaitKey('���������죮',M_White)
end
end
end
return false
end

function SettingMenu() --�����趨
local x,y,w,h
local size=16
w=320
h=128+64
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
notWar=false
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
notWar=true
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
notWar=true
end
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+92+64
local y2=y1+24
local function button(bx,by,str,flag)
local box_w=36
local box_h=18
local cx=bx
local cy=by-1
if flag then--selected
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,128,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Black)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Black)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Gray)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Gray)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_White,size)
else
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,192,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Gray)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Gray)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Black)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Black)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_Silver,size)
end
end
local function redraw(flag)
local T={[0]="�ر�","��","��","��","��","��"}
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
DrawSMap()
else
end
lib.PicLoadCache(4,80*2,x,y,1)
lib.SetClip(x,y+72,x+w,y+72+128-8)
lib.PicLoadCache(4,80*2,x,y+72-8,1)
lib.SetClip()
DrawString(x+16,y+16,"�����趨",C_Name,size)
DrawStr(x+16,y+40,"����",M_White,size)
for i,v in pairs(T) do
if math.modf(CC.MusicVolume/20)==i then
button(x+80+i*38,y+40,v,true)
else
button(x+80+i*38,y+40,v,false)
end
end
DrawStr(x+16,y+60,"��Ч",M_White,size)
for i,v in pairs(T) do
if math.modf(CC.SoundVolume/10)==i then
button(x+80+i*38,y+60,v,true)
else
button(x+80+i*38,y+60,v,false)
end
end
DrawStr(x+16,y+80,"����",M_White,size)
if CC.FontType==0 then
button(x+80+1*38,y+80,"��",true)
button(x+80+2*38,y+80,"��",false)
else
button(x+80+1*38,y+80,"��",false)
button(x+80+2*38,y+80,"��",true)
end
if notWar then
DrawStr(x+16,y+100,"����",M_White,size)
if CC.font==0 then
button(x+80+1*38,y+100,"����",true)
button(x+80+2*38,y+100,"����",false)
else
button(x+80+1*38,y+100,"����",false)
button(x+80+2*38,y+100,"����",true)
end
DrawStr(x+16,y+120,"�о�����",M_White,size)
if JY.Base["�о�����"]>0 then
button(x+80+1*38,y+120,"����",true)
button(x+80+2*38,y+120,"�ر�",false)
else
button(x+80+1*38,y+120,"����",false)
button(x+80+2*38,y+120,"�ر�",true)
end
else
DrawStr(x+16,y+100,"�ƶ�����",M_White,size)
if CC.MoveSpeed==1 then
button(x+80+1*38,y+100,"����",true)
button(x+80+2*38,y+100,"�ر�",false)
else
button(x+80+1*38,y+100,"����",false)
button(x+80+2*38,y+100,"�ر�",true)
end
DrawStr(x+16,y+120,"���Զ���",M_White,size)
if CC.cldh==1 then
button(x+80+1*38,y+120,"����",true)
button(x+80+2*38,y+120,"�ر�",false)
else
button(x+80+1*38,y+120,"����",false)
button(x+80+2*38,y+120,"�ر�",true)
end
DrawStr(x+16,y+140,"ս������",M_White,size)
if CC.zdby==0 then
button(x+80+1*38,y+140,"����",false)
button(x+80+2*38,y+140,"�ر�",true)
else
button(x+80+1*38,y+140,"����",true)
button(x+80+2*38,y+140,"�ر�",false)
end
end
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
if notWar then
ShowScreen()--���������תΪ����
else
ReFresh()
end
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return
else
current=0
for i=0,5 do
if MOUSE.CLICK(x+80+i*38,y+40,x+80+i*38+36,y+40+16) then
CC.MusicVolume=20*i
Config()
PicCatchIni()
PlayWavE(0)
break
elseif MOUSE.CLICK(x+80+i*38,y+60,x+80+i*38+36,y+60+16) then
CC.SoundVolume=10*i
Config()
PicCatchIni()
PlayWavE(0)
break
end
end
if MOUSE.CLICK(x+80+1*38,y+80,x+80+1*38+36,y+80+16) then
CC.FontType=0
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+80,x+80+2*38+36,y+80+16) then
CC.FontType=1
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+100,x+80+1*38+36,y+100+16) then
if notWar then
CC.FontName=CONFIG.FontName
CC.font=0
else
CC.MoveSpeed=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+100,x+80+2*38+36,y+100+16) then
if notWar then
CC.FontName=CONFIG.FontName2
CC.font=1
else
CC.MoveSpeed=0
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+120,x+80+1*38+36,y+120+16) then
if notWar then
JY.Base["�о�����"]=1
else
CC.cldh=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+120,x+80+2*38+36,y+120+16) then
if notWar then
JY.Base["�о�����"]=0
else
CC.cldh=0
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+140,x+80+1*38+36,y+140+16) then
if notWar then
else
CC.zdby=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+140,x+80+2*38+36,y+140+16) then
if notWar then
else
CC.zdby=0
end
PlayWavE(0)
end
end
end
end

function WarGetPic(id)
--[[
0 �̱�
1 �̱�
2 ����
3 ս��
4 ����
5 ���
6 Ͷʯ��
7 �����
8 �����
9 ������
10 ɽ��
11 ����
12 ����
13 ���ֶ�
14 ���ޱ���
15 ������
16 ����ʦ
17 ������
18 ����
19 �����
5020 5070 5120 �ܲ�(ԭ��)
5170 5220 5270 �ĺ(ԭ��)
5320 5370 5420 ����(ԭ��)
5470 5520 5570 ����(ԭ��)
5620 5670 5720 ˾��ܲ(ԭ��)
5770 ����(ԭ�棬����)
5820 ���(����)
5870 ���(ԭ��)
5920 ½ѷ(ԭ��)
5970 6020 6070 ��Τ(ԭ��)
6120 6170 6220 ����(ԭ��)
6270 ף��(ԭ��)
6320 ����(ԭ��)
6370 6420 ����(ԭ��)
6470 6520 �ŷ�(ԭ��)
6570 ����(ԭ��)
6620 �׵�(ԭ��)
6670 ����(ԭ��)
6720 ��ά ����
6770 6820 ���� ����
6870 �λ� ����
6920 7420 ���� ����
6970 ��ͳ(��˫)
7020 ����
7070 ���(����־)
7120 ���� ����
7170 �ŷ� ����
7220 ����(ˮ�)
7270 ���� ����
7320 ����? ����
7370 ����
7470 ˾��ܲ ����
7520 Ů����
7570 ����
7620 ���� ����
7670 ³����(ˮ�)
7720 ½ѷ(����־)
7770 ��� ����
7820 ��� ����
7870 ˫����Ů
7920 �ܲ� ����
7970 �С�ǹ��˫ꪡ��ס�����
8020 ��Τ ����
8070 8120 ���� ����
8170 8220 ���� �ĳ� ����
8270 ���� ����
8320 ���� ����
8370 8420 ̫ʷ�� ����
8470 ����(�ֻ�) ����
8520 ˫�ȡ�Ů ����
8570 κ�� ����
8620 ���� ����
8670 ��׿ ����
8720 ����
8770 �Ƹ�
8820 ���� ��
8870 ���� ����
8920 ��
8970 ��� ����
9020 ���� ��
9070 ��̩ ����
9120 ���� ����
9170 ��˳ ѵ��
9220 ɳĦ�� �ټ�
9270 ��� �ڽ�
9320 ��� ñ��
9820 �ܲ�san10��� ����
9870 ������ ���� ��
9920 �˰� ����
9970 10020 10070 10120 ��ƽ����1-4
10170 10220 ���� ����
10270 ˫����
10320 �������
10370 ������������
10420 ���������ܣ���
10470 ������ǹ����
10520 ����趣�����
10570 �������
10620 ���ˣ���
10670 ���ˣ�����
10720 ���ͣ���
10770 ��䣬����
10820 ��䣬����
10870 ���գ�����ʦ
10920 - 11320 ǹ��
11370 ɳĦ�£�����
11420 ɳĦ�£�����
11470 �Ű�������
11520 - 11670 ����s10������ lv3,move��lv2һ����ԭ����������Ϸ���������
11670 ���ƣ�����
11720 ��Ȩ����ߣ���ᣬԭ��
11770 Ԭ�ܣ�ԭ��
]]--
local pid=War.Person[id].id
return GetPic(pid,War.Person[id].enemy,War.Person[id].friend)
end

function GetBZPic(pid,enemy,friend)
local pic=20
local bz=JY.Person[pid]["����"]
local lv=1
if JY.Person[pid]["�ȼ�"]<20 then
lv=1
elseif JY.Person[pid]["�ȼ�"]<40 then
lv=2
else
lv=3
end
pic=JY.Bingzhong[bz]["��ͼ"..lv]
if enemy then
return pic+JY.Bingzhong[bz]["�о�ƫ��"]
elseif friend then
return pic+JY.Bingzhong[bz]["�Ѿ�ƫ��"]
else
return pic+JY.Bingzhong[bz]["�Ҿ�ƫ��"]
end 
end

function GetPic(pid,enemy,friend)
--[[
if bz>12 then
 bz=12+(bz-13)*3+lv
end
-- 1 4 7 10 13 16 19 22 25 28 31 34 37 40
-- ���� ���� ��� ���� �ֶ� ���� ������ ����ʦ ���� ���� ���� ս�� Ͷʯ�� ͻ���
local T1={[0]=20,20,170,320, 920,1070,1220, 470,620,770, 1370,1520,1670, 3620,3620,3620, 3170,3170,3170, 1820,1970,2120, 2720,2870,3020, 3320,3320,3320, 3570,3570,3570, 3770,3770,3770, 3920,4070,4220, 4370,4520,4670, 9370,9520,9670,}--�о� ��
local T2={[0]=70,70,220,370, 970,1120,1270, 520,670,820, 1420,1570,1720, 3670,3670,3670, 3220,3220,3220, 1870,2020,2170, 2770,2920,3070, 3370,3370,3370, 3570,3570,3570, 3820,3820,3820, 3970,4120,4270, 4420,4570,4720, 9420,9570,9720,}--�Ѿ� ��
local T3={[0]=120,120,270,420, 1020,1170,1320, 570,720,870, 1470,1620,1770, 3720,3720,3720, 3270,3270,3270, 1920,2070,2220, 2820,2970,3120, 3420,3420,3420, 3570,3570,3570, 3870,3870,3870, 4020,4170,4320, 4470,4620,4770, 9470,9620,9770,}--�Ҿ� ��
 
if enemy then
JY.Person[pid]["ս������"]=T1[bz] or 20
elseif friend then
JY.Person[pid]["ս������"]=T2[bz] or 70
else
JY.Person[pid]["ս������"]=T3[bz] or 120
end 
 ]]--
local bz=JY.Person[pid]["����"]
local lv=1
if bz==3 or bz==6 or bz==9 or bz==12 then
lv=3
elseif bz==2 or bz==5 or bz==8 or bz==11 then
lv=2
elseif bz==1 or bz==4 or bz==7 or bz==10 then
lv=1
elseif JY.Person[pid]["�ȼ�"]<20 then
lv=1
elseif JY.Person[pid]["�ȼ�"]<40 then
lv=2
else
lv=3
end
JY.Person[pid]["ս������"]=GetBZPic(pid,enemy,friend)
local id=JY.Person[pid]["����"]
if id==1 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=6320
elseif lv==2 then
JY.Person[pid]["ս������"]=12120
else
JY.Person[pid]["ս������"]=12170
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
elseif bz==27 then
JY.Person[pid]["ս������"]=10320
else--����
if lv<3 then
JY.Person[pid]["ս������"]=6920
else
JY.Person[pid]["ս������"]=7420
end
end
elseif id==2 or id==373 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=6370
elseif lv==2 then
JY.Person[pid]["ս������"]=6420
elseif lv==3 then
JY.Person[pid]["ս������"]=7120
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=11870
end
elseif id==3 or id==374 then--�ŷ�
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=6470
elseif lv==2 then
JY.Person[pid]["ս������"]=6520
elseif lv==3 then
JY.Person[pid]["ս������"]=7170
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=12570
end
elseif id==4 then--��׿
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8670
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==5 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=6670
elseif lv==2 or lv==3 then
JY.Person[pid]["ս������"]=12220
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7620
end
elseif id==6 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=11970
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==9 then--�ܲ�
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=5020
elseif lv==2 then
JY.Person[pid]["ս������"]=5070
elseif lv==3 then
JY.Person[pid]["ս������"]=5120
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==10 then--Ԭ��
JY.Person[pid]["ս������"]=11770
elseif id==11 then--���
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=7770
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==13 then--�����
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=10520
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==15 then--�Ƹ�
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=8770
end
elseif id==17 then--�ĺ
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=5170
elseif lv==2 then
JY.Person[pid]["ս������"]=5220
elseif lv==3 then
JY.Person[pid]["ս������"]=5270
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==18 then--�ĺ�Ԩ
if between(bz,7,9) or bz==20 or bz==22 then--����
if true or bz==22 then
if lv==1 then
JY.Person[pid]["ս������"]=12320
elseif lv==2 then
JY.Person[pid]["ս������"]=12370
elseif lv==3 then
JY.Person[pid]["ս������"]=12420
else
end
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==19 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=8620
end
elseif id==30 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==3 and JY.Person[pid]["�ȼ�"]>=60 then
JY.Person[pid]["ս������"]=10670
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=10620
end
elseif id==31 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==16 then--����ʦ
JY.Person[pid]["ս������"]=10870
elseif bz==21 then--Ͷʯ��һ������������
else--����
if lv==1 then
JY.Person[pid]["ս������"]=10170
elseif lv==2 then
JY.Person[pid]["ս������"]=10170
elseif lv==3 then
JY.Person[pid]["ս������"]=10220
end
end
elseif id==34 then--�λ�
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=6870
end
elseif id==35 then--ɳĦ��
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=11420
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=11370--9220
end
elseif id==44 then--�Ű�
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==3 and JY.Person[pid]["�ȼ�"]>=60 then
JY.Person[pid]["ս������"]=11470
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==52 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8170
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==53 then--�ĳ�
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8220
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==54 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=6570
elseif lv==2 then
JY.Person[pid]["ս������"]=6770
elseif lv==3 then
JY.Person[pid]["ս������"]=6820
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=9120
end
elseif id==68 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8320
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
if lv==1 then
JY.Person[pid]["ս������"]=6120
elseif lv==2 then
JY.Person[pid]["ս������"]=6170
elseif lv==3 then
JY.Person[pid]["ս������"]=6220
else
end
end
elseif id==70 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=8070
elseif lv==2 then
JY.Person[pid]["ս������"]=8120
elseif lv==3 then
JY.Person[pid]["ս������"]=8120
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==73 then--��˳
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==14 then--ѵ��һ������������
JY.Person[pid]["ս������"]=9170
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==79 then--���
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=7820
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==80 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=5320
elseif lv==2 then
JY.Person[pid]["ս������"]=5370
elseif lv==3 then
JY.Person[pid]["ս������"]=5420
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7320
end
elseif id==83 then--��Ӻ
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����
if lv>1 then
JY.Person[pid]["ս������"]=12070
end
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==103 then--���A
if between(bz,7,9) or bz==20 or bz==22 then--����
if true or bz==22 then
JY.Person[pid]["ս������"]=12520
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==116 then--���
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=10820
end
elseif id==126 then--�����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
if between(JY.Person[pid]["�ȼ�"],1,39) then
JY.Person[pid]["ս������"]=9270
elseif between(JY.Person[pid]["�ȼ�"],40,59) then
JY.Person[pid]["ս������"]=5820
elseif between(JY.Person[pid]["�ȼ�"],60,9999) then
JY.Person[pid]["ս������"]=9320
else
end
end
elseif id==127 then--κ��
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8570
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==128 then--��ƽ
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=9970
elseif lv==2 then
JY.Person[pid]["ս������"]=10070
elseif lv==3 then
JY.Person[pid]["ս������"]=10120
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==129 then--�ĺ���
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=9870
end
elseif id==133 then--��ͳ
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=6970
end
elseif id==142 then--��Ȩ
JY.Person[pid]["ս������"]=11720
elseif id==143 then--���
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7070
end
elseif id==150 then--̫ʷ��
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=8370
elseif lv==2 then
JY.Person[pid]["ս������"]=8420
elseif lv==3 then
JY.Person[pid]["ս������"]=8420
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==151 then--½ѷ
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7720
end
elseif id==155 then--�ܲ�
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7920
end
elseif id==163 then--��̩
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=9070
end
elseif id==170 then--����
if between(bz,7,9) then--����
JY.Person[pid]["ս������"]=8870
elseif bz==22 then--����
JY.Person[pid]["ս������"]=12020
elseif bz>=4 and bz<=6 then--����һ������������
JY.Person[pid]["ս������"]=8820
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==190 then--��
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8920
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==196 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
JY.Person[pid]["ս������"]=9020
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==204 then--���
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=8970
end
elseif id==214 then--˾��ܲ
if between(bz,7,9) or bz==20 or bz==22 then--����
if lv==1 then
JY.Person[pid]["ս������"]=5620
elseif lv==2 then
JY.Person[pid]["ս������"]=5670
elseif lv==3 then
JY.Person[pid]["ս������"]=5720
else
end
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7470
end
elseif id==216 then--�ӵ�
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=10770
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==244 then--��ά
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=6720
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
end
elseif id==376 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==14 then--ѵ��һ������������
JY.Person[pid]["ս������"]=8270
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=10570
end
elseif id==377 then--ף��
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=6270
end
elseif id==383 then--�׵�
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=6620
end
elseif id==385 then--³����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7670
end
elseif id==386 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=7220
end
elseif id==387 then--��Τ
if between(bz,7,9) or bz==20 or bz==22 then--����
JY.Person[pid]["ս������"]=8020
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
if lv==1 then
JY.Person[pid]["ս������"]=5970
elseif lv==2 then
JY.Person[pid]["ս������"]=5970
elseif lv==3 then
JY.Person[pid]["ս������"]=6020
else
end
end
elseif id==388 then--����
JY.Person[pid]["ս������"]=7020
elseif id==389 then--����
JY.Person[pid]["ս������"]=7520
elseif id==390 then--����
JY.Person[pid]["ս������"]=7570
elseif id==391 then
JY.Person[pid]["ս������"]=7620
elseif id==392 then
JY.Person[pid]["ս������"]=7120
elseif id==393 then
JY.Person[pid]["ս������"]=7170
elseif id==394 then
JY.Person[pid]["ս������"]=8470
elseif id==395 then
JY.Person[pid]["ս������"]=8570
elseif id==396 then
JY.Person[pid]["ս������"]=8020
elseif id==397 then
JY.Person[pid]["ս������"]=5420
elseif id==398 then
JY.Person[pid]["ս������"]=6220
elseif id==404 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
if lv==1 then
JY.Person[pid]["ս������"]=5470
elseif lv==2 then
JY.Person[pid]["ս������"]=5520
elseif lv==3 then
JY.Person[pid]["ս������"]=5570
else
end
end
elseif id==405 then--����
if between(bz,7,9) or bz==20 or bz==22 then--����
elseif bz>=4 and bz<=6 then--����һ������������
elseif bz==21 then--Ͷʯ��һ������������
else--����
JY.Person[pid]["ս������"]=8720
end
elseif id==406 then--bttt
JY.Person[pid]["ս������"]=12270
end
return JY.Person[pid]["ս������"]
end

function FightMenu()
local T={ 5,3,387,2,54,68,
190,385,17,170,98,
391,392,393,394,395,396,397,398,
150,216,386,390,44,127,389,35,
53,79,148,6,11,
18,80,103,244,4,
30,201,52,163,196,388,
15,142,202,155,122,
149,204,171,377,167,
212,19,128,151,109,
34,178,236,1,9,104,
143,165,174,254,20,
102,218,61,106,191,
129,141,166,205,252,
116,13,200,46,70,88,113,
210,376,14,168,211,
213,217,243,81,162,
208,209,248,241,31,
91,105,240,47,82,
117,221,48,144,45,
51,63,87,136,378,
10,73,146,76,380,
38,188,133,214,50,
57,112,126,83,65,
77,94,64,69,62,
145,84,251,7,379,
253,114,239,402,403,
404,405,382,406,
}
local id1=FightSelectMenu(T)
if id1==0 then
return
end
for i,v in pairs(T) do
if id1==v then
 table.remove(T,i)
break
end
end
local id2=FightSelectMenu(T)
if id2==0 then
return
end
local s={0,1,2,4,6}
fight(id1,id2,s[math.random(5)])
end

function FightSelectMenu(T)
local num_perpage=12
local page=1
local total_num=#T
local maxpage=math.modf(total_num/(num_perpage-2))
if total_num>(num_perpage-2)*maxpage then
maxpage=maxpage+1
end
local t={}
while true do
for i=2,num_perpage-1 do
t[i]=0
end
t[1]=-1
t[num_perpage]=-2
for i=2,num_perpage-1 do
local idx=(num_perpage-2)*(page-1)+(i-1)
if idx<=total_num then
t[i]=T[idx]
end
end
local m={}
m[1]={" ��һҳ",nil,1}
m[num_perpage]={" ��һҳ",nil,1}
for i=2,num_perpage-1 do
if t[i]>0 then
local str=JY.Person[t[i]]["����"]
if #str==6 then
str=" "..str
elseif #str==4 then
str="��"..str
elseif #str==3 then
str="�� "..str
elseif #str==2 then
str="�� "..str
end
m[i]={str,nil,1}
else
m[i]={"",nil,0}
end
end
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
DrawSMap()
else
lib.FillColor(0,0,0,0)
end
local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,M_White,M_White)
if r==1 then
if page>1 then
page=page-1
end
elseif r==num_perpage then
if page<maxpage then
page=page+1
end
elseif r==0 then
return 0
else
local id=t[r]
local bz=JY.Person[id]["����"]
if WarDrawStrBoxYesNo(string.format('%s %d��%s ���� %d*ȷ����',JY.Person[id]["����"],JY.Person[id]["�ȼ�"],JY.Bingzhong[bz]["����"],JY.Person[id]["����"]),M_White,true) then
return t[r]
end
end
end
end

function LvMenu(T)
local num_perpage=12
local page=1
local total_num=#T
local maxpage=math.modf(total_num/(num_perpage-2))
if total_num>(num_perpage-2)*maxpage then
maxpage=maxpage+1
end
local t={}
while true do
for i=2,num_perpage-1 do
t[i]=0
end
t[1]=-1
t[num_perpage]=-2
for i=2,num_perpage-1 do
local idx=(num_perpage-2)*(page-1)+(i-1)
if idx<=total_num then
t[i]=T[idx]
end
end
local m={}
m[1]={" ��һҳ",nil,1}
m[num_perpage]={" ��һҳ",nil,1}
for i=2,num_perpage-1 do
if t[i]>0 then
local str=t[i]
m[i]={"�� "..str,nil,1}
else
m[i]={"",nil,0}
end
end
local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,M_White,M_White)
if r==1 then
if page>1 then
page=page-1
end
elseif r==num_perpage then
if page<maxpage then
page=page+1
end
elseif r==0 then
return 0
else
return t[r]
end
end
end

--ԭS.lua
function Config()
lib.LoadConfig(CC.ScreenW,CC.ScreenH)
end

function SystemMenu()
PlayWavE(0)
local menu={
{" ������Ϸ",nil,1},
{"�� ����",nil,1},
{"�� ����",nil,1},
{" �����趨",nil,1},
{"�� ��Ч ",nil,0},
}
DrawYJZBox(32,32,"����",M_White,true)
local r=ShowMenu(menu,5,0,0,0,0,0,3,1,16,M_White,M_White)
lib.Delay(100)
if r==1 then
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('����һ����',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif r==2 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."δʹ�õ���"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"��ѡ������ĵ���",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="δʹ�õ���" then
if WarDrawStrBoxYesNo(string.format("������Ӳ���ĵ�%d���ȣ�������",s2),M_White,true) then
LoadRecord(s2)
end
else
WarDrawStrBoxConfirm("û������",M_White,true)
end
end
elseif r==3 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."δʹ�õ���"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"���������������",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("������Ӳ���ĵ�%d�ţ�������",s2),M_White,true) then
SaveRecord(s2)
end
end
elseif r==4 then
SettingMenu()--�����趨
elseif r==5 then
end
return false
end

function GetRecordInfo(id)
local offset=CC.Base_S["�½���"][1]+100
local len=CC.Base_S["�½���"][3]+CC.Base_S["ʱ��"][3]
local data=Byte.create(8*len)
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
local SectionName,SaveTime
SectionName=Byte.getstr(data,0,28)
SaveTime=Byte.getstr(data,28,14)
offset=CC.Base_S["ս���浵"][1]+100
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
if Byte.get16(data,0)==1 then
offset=CC.Base_S["ս������"][1]+100
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
SectionName=Byte.getstr(data,0,28)
offset=100+136
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
local turn=Byte.get8(data,8)
local maxturn=Byte.get8(data,9)
SectionName=string.gsub(SectionName,"�� ","��")
if string.len(SectionName)<22 then
SectionName=string.format(string.format("%%s%%%ds",22-string.len(SectionName)),SectionName,"")..string.format("��%02d�غ�",turn,maxturn)
end
end
if CC.SrcCharSet==1 then
SectionName=lib.CharSet(SectionName,0)
end
if string.len(SectionName)<31 then
SectionName=string.format(string.format("%%s%%%ds",31-string.len(SectionName)),SectionName,"")
end
return SectionName..SaveTime
end

function SetSceneID(id,BGMID)
JY.SubScene=id
Dark()
if BGMID~=nil then
PlayBGM(BGMID)
end
DrawSMap()
Light()
end

function SMapEvent()
JY.ReFreshTime=lib.GetTime()
DrawSMap()
JY.Tid=0
local eventtype,keypress,x,y=getkey()
if MOUSE.HOLD(673,321,710,366) then
lib.PicLoadCache(4,220*2,673,321,1)
elseif MOUSE.HOLD(713,321,750,366) then
lib.PicLoadCache(4,221*2,713,321,1)
elseif MOUSE.HOLD(673,369,710,414) then
lib.PicLoadCache(4,222*2,673,369,1)
elseif MOUSE.HOLD(713,369,750,414) then
lib.PicLoadCache(4,223*2,713,369,1)
end
if MOUSE.CLICK(673,321,710,366) then
PlayWavE(0)
if CC.Enhancement==false then
WarDrawStrBoxConfirm("���޿��������佫��",M_White,true)
else
HirePerson()
end
elseif MOUSE.CLICK(713,321,750,366) then
PlayWavE(0)
Person_Menu()
elseif MOUSE.CLICK(673,369,710,414) then
Shop()
elseif MOUSE.CLICK(713,369,750,414) then
SystemMenu()
elseif MOUSE.CLICK(680,24,742,102) then
JY.LLK_N=JY.LLK_N+1
if JY.LLK_N>49 then
PlayWavE(0)
if WarDrawStrBoxYesNo("��ֹ����������ģʽ*��ִ�н�������κ����Σ�*���ҶԴ˵�ѯ��Ҳ����𣮿�����",M_White,true) then--���Խ����������Ұ��״̬��
local mj=0
if CC.Enhancement==false then
mj=1
end
if mj==1 then
JY.Base["�ƽ�"]=9999
JY.Person[1]["�ȼ�"]=99
JY.LLK_N=0
elseif mj==0 then
Game_Cycle()
end
else
JY.LLK_N=50
end
end
end
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('����һ����',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
end
if MOUSE.IN(16,16,16+640,16+400) then
for i,v in pairs(JY.Smap) do
local px,py=27+18*v[2],19+18*v[3]-32
--if math.abs(x-px)<20 and math.abs(y-py)<28 then
if MOUSE.CLICK(px-20,py-28,px+20,py+28) then
JY.Tid=v[1]
 DoEvent(JY.EventID)
if JY.Tid==-1 then
JY.Tid=0
return
end
JY.Tid=0
break
elseif MOUSE.IN(px-20,py-28,px+20,py+28) then
JY.Tid=v[1]
end
end
end
if eventtype==3 and keypress==3 then
SystemMenu()
end
if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
ReFresh()
end
end

function DrawSMap()
lib.FillColor(0,0,0,0,0)
if JY.SubScene>=0 then
lib.PicLoadCache(5,JY.SubScene*2,16,16,1)--21,21
local len=18
local dx,dy=27,19
if CC.Debug==1 then
for i=1,20 do
lib.Background(0,dy+len*i,CC.ScreenW,dy+len*i+1,128,M_White)
DrawString(42,dy+len*i,i,M_White,16)
DrawString(dx+len*i*2,24,i*2+1,M_White,16)
lib.Background(dx+len*i*2,0,dx+len*i*2+1,CC.ScreenH,128,M_White)
end
end
for i,v in pairs(JY.Smap) do
local x,y=dx+len*v[2]-24,dy+len*v[3]-64
lib.SetClip(x,y,x+48,y+64)
if v[5]==0 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["����"]*4+v[4])*2,x,y-0*64,1)
elseif v[5]==1 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["����"]*4+v[4])*2,x,y-1*64,1)
elseif v[5]==2 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["����"]*4+v[4])*2,x,y-0*64,1)
elseif v[5]==3 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["����"]*4+v[4])*2,x,y-2*64,1)
elseif v[5]==4 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["����"]*4+v[4])*2,x,y-0*64,1)
end
if v[5]>=1 then
v[5]=v[5]+1
if v[5]==5 then
v[5]=1
end
end
lib.SetClip(0,0,0,0)
end
for i,v in pairs(JY.Smap) do
if v[5]==0 then
if JY.Tid==v[1] then
local x,y=dx+len*v[2]-24,dy+len*v[3]-64
if v[4]==1 or v[4]==2 then
lib.PicLoadCache(4,232*2,x-8,y-8,1)
else
lib.PicLoadCache(4,231*2,x+32,y-8,1)
end
end
end
end
end
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
end

function DrawGameStatus()
DrawString(680,142,"��",M_Navy,16)
DrawString(680,182,"�ȼ�",M_Navy,16)
DrawString(680,222,"�佫",M_Navy,16)
DrawString(680,262,"���ڵ�",M_Navy,16)
DrawString(740-#(""..JY.Base["�ƽ�"])*16/2, 160,JY.Base["�ƽ�"],M_White,16)
DrawString(740-#(""..JY.Person[1]["�ȼ�"])*16/2,200,JY.Person[1]["�ȼ�"],M_White,16)
DrawString(740-#(""..JY.Base["�佫����"])*16/2, 240,JY.Base["�佫����"],M_White,16)
DrawString(740-#JY.Base["���ڵ�"]*16/2, 280,JY.Base["���ڵ�"],M_White,16)
DrawString(18+6,434+6,JY.Base["�½���"],M_White,16)
if JY.Tid>0 then
DrawString(338+6,434+6,JY.Person[JY.Tid]["����"],M_White,16)
end
end

function MovePerson(...)
local arg={}
for i,v in pairs({...}) do
arg[i]=v
end
local n=math.modf(#arg/3)
for i=0,n-1 do
local id=arg[i*3+1]
for ii,v in pairs(JY.Smap) do
if v[1]==id then
arg[i*3+1]=ii
v[5]=1
end
end
end
while true do
local flag=true
for i=0,n-1 do
local id=arg[i*3+1]
local d=arg[i*3+3]
JY.Smap[id][4]=d
if arg[i*3+2]>0 then
flag=false
JY.Smap[id][2]=JY.Smap[id][2]+CC.DX[d]*0.2
JY.Smap[id][3]=JY.Smap[id][3]+CC.DY[d]*0.2
arg[i*3+2]=arg[i*3+2]-0.2
else
JY.Smap[id][5]=0
end
end
JY.ReFreshTime=lib.GetTime()
DrawSMap()
lib.GetKey()
ReFresh(1.25)
if flag then
break
end
end
for i,v in pairs(JY.Smap) do
 v[5]=0
end
DrawSMap()
lib.GetKey()
ShowScreen()--���������תΪ����
lib.Delay(50)
SortPerson()
end

function SortPerson()
local n=#JY.Smap
for i=1,n-1 do
for j=i+1,n do
if JY.Smap[i][3]>JY.Smap[j][3] then
JY.Smap[i],JY.Smap[j]=JY.Smap[j],JY.Smap[i]
end
end
end
end

function DoEvent(id)
if type(Event[id])=='function' then
Event[id]()
else
lib.Debug("Error!! eid="..id.."��type="..type(Event[id]))
JY.Status=GAME_START
end
if id>9999 then
os.exit()
end
if id~=JY.EventID then
return true
else
return false
end
end

function NextEvent(id)
if id==nil then
JY.EventID=JY.EventID+1
else
JY.EventID=id
end
end

function PicCatchIni()
lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0)
lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1)
lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2)
--3����ʹ��
lib.PicLoadFile(CC.UIPicFile[1],CC.UIPicFile[2],4)
lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5)
lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200)
end

function Password()
local f=0
local T3={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
local str=""
if filelength( CONFIG.PicturePath..
CC.PASCODE[29]..CC.PASCODE[8]..CC.PASCODE[5]..CC.PASCODE[14]..CC.PASCODE[50]..CC.PASCODE[53]..
CC.PASCODE[4]..CC.PASCODE[5]..CC.PASCODE[2]..CC.PASCODE[21]..CC.PASCODE[7])==13 then--".\\ChenX.debug")==13 then
CC.Debug=0
return
end
while true do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(4,83*2,0,0,1)
if f==0 then
lib.FillColor(40,14,49,16)
end
f=1-f
ReFresh()
local key=lib.GetMouse()
if key==1 or key==3 then
break
end
end
Dark()
end

function ScreenTest()
while true do
local e,k,x,y=lib.GetMouse(1)
lib.FillColor(0,0,0,0,M_White)
if e==2 or e==3 then
lib.DrawRect(x-64,y,x+64,y,0)
lib.DrawRect(x,y-64,x,y+64,0)
end
DrawString(64,64,x..','..y,M_Orange,24)
ShowScreen()--���������תΪ����
lib.Delay(25)
end
end

function YJZMain()
local saveflag=false--ս����ʾ������
JY.Status=GAME_START--��Ϸ��ǰ״̬
PicCatchIni()
Password()
LoadRecord(0)
for i=1,JY.PersonNum-1 do
GetPic(i)
end
while true do
if JY.Status==GAME_START then
StopBGM()
YJZMain_sub()
elseif JY.Status==GAME_SMAP_AUTO then
if saveflag then
Dark()
saveflag=false
lib.FillColor(0,0,0,0,0)
RemindSave(2)
end
DoEvent(JY.EventID)
elseif JY.Status==GAME_SMAP_MANUAL then
SMapEvent()
elseif JY.Status==GAME_MMAP then
elseif JY.Status==GAME_WMAP then
Dark()
saveflag=true
WarStart()
elseif JY.Status==GAME_WMAP2 then--����ս��
JY.Status=GAME_WMAP
DoEvent(JY.EventID)
elseif JY.Status==GAME_WARWIN then
JY.Status=GAME_SMAP_AUTO
elseif JY.Status==GAME_WARLOSE then
JY.Status=GAME_START
elseif JY.Status==GAME_DEAD then
elseif JY.Status==GAME_END then
Dark()
lib.Delay(1000)
os.exit()
end
end
end

function YJZMain_sub()
local menu={
{"�� ��ʼ����Ϸ",nil,1},
{"������ȡ�浵",nil,1},
{"���������趨",nil,1},
{"����ս������",nil,1},
{"����������",nil,1},
{"���ۿ�������",nil,1},
{"�����˳���Ϸ",nil,1},
}
if CC.Debug==1 then
menu[4][3]=1
end
lib.FillColor(0,0,0,0)
lib.Delay(200)
local s=ShowMenu(menu,7,0,0,0,0,0,2,0,16,M_White,M_White)
if s==1 then
LoadRecord(0)
JY.Base["�½���"]=""
local menux={
{"��������ģʽ",nil,1},
{"�����ݺ�ģʽ",nil,1},
}
local ss=ShowMenu(menux,2,0,0,0,0,0,2,0,16,M_White,M_White)
if ss==1 then
JY.Base["��Ϸģʽ"]=0
SaveRecord(6)-- д��Ϸ����
LoadRecord(6)-- ��ȡ��Ϸ����
os.remove(CC.R_GRPFilename[6])--ɾ����ʱ�浵
elseif ss==2 then
JY.Base["��Ϸģʽ"]=1
SaveRecord(6)-- д��Ϸ����
LoadRecord(6)-- ��ȡ��Ϸ����
os.remove(CC.R_GRPFilename[6])--ɾ����ʱ�浵
JY.Person[1]["�ȼ�"]=3
JY.Person[2]["�ȼ�"]=3
JY.Person[3]["�ȼ�"]=3
end
for i=1,JY.PersonNum-1 do
GetPic(i)
end
JY.Status=GAME_SMAP_AUTO--��Ϸ��ǰ״̬
JY.EventID=1
elseif s==2 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."δʹ�õ���"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,128,"��ѡ������ĵ���",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="δʹ�õ���" then
if WarDrawStrBoxYesNo(string.format("������Ӳ���ĵ�%d���ȣ�������",s2),M_White,true) then
LoadRecord(s2)
end
else
WarDrawStrBoxConfirm("û������",M_White,true)
end
end
elseif s==3 then
SettingMenu()--�����趨
elseif s==4 then
LoadRecord(0)
for i=1,JY.PersonNum-1 do
GetPic(i)
end
JY.Status=GAME_SMAP_AUTO--��Ϸ��ǰ״̬

--����
JY.Base["��Ϸģʽ"]=1
CC.Enhancement=true
JY.EventID=700
JY.Base["�¼�333"]=30
JY.Person[1]["�ȼ�"]=99
JY.Person[2]["�ȼ�"]=99
JY.Person[3]["�ȼ�"]=99
JY.Base["�ƽ�"]=10000
elseif s==5 then
PlayBGM(18)
FightMenu()
elseif s==6 then
lib.PicLoadFile(CC.EFT[1],CC.EFT[2],6)
PlayBGM(2)
local cx,cy=(CC.ScreenW-640)/2,(CC.ScreenH-480)/2
for picid=0,1236 do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(6,picid*2,cx,cy,1)
ReFresh(8)
local eventtype=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
Dark()
lib.Delay(1000)
break
end
end
PicCatchIni()
elseif s==7 then
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
lib.Delay(100)
JY.Status=GAME_END
end
end
end

function DrawStrBoxCenter(str,color)--��ʾ������ַ���
color=color or M_White
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
WarDrawStrBoxWaitKey(str,color,-1,-1)
else
DrawStrBoxWaitKey(str,color)
end
end

function GenTalkString(str,n)--�����Ի���ʾ��Ҫ���ַ���
local tmpstr=str
local num=0
local newstr=""
while #tmpstr>0 do
num=num+1
local w=0
while w<#tmpstr do
local v=string.byte(tmpstr,w+1)--��ǰ�ַ���ֵ
if v==42 then
break
elseif v>=128 then
w=w+2
else
w=w+1
end
if w >=2*n-1 then--Ϊ�˱����������ַ�
break
end
end
if w<#tmpstr then
if string.byte(tmpstr,w+1)==42 then
newstr=newstr .. string.sub(tmpstr,1,w+1)
tmpstr=string.sub(tmpstr,w+2,-1)
elseif w==2*n-1 and string.byte(tmpstr,w+1)<128 then
newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*"
tmpstr=string.sub(tmpstr,w+2,-1)
else
newstr=newstr .. string.sub(tmpstr,1,w) .. "*"
tmpstr=string.sub(tmpstr,w+1,-1)
end
else
newstr=newstr .. tmpstr
break
end
end
return newstr,num
end

function DrawMulitStrBox(str,color,size)--��ʾ���о���
local x,y=145,250
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x,y=113,298
end
local sid=lib.SaveSur(x,y,x+382,y+126)
color=color or M_White
size=size or 16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,21)
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
lib.PicLoadCache(4,50*2,x,y,1)
for i=1,num do
DrawString(x+CC.MenuBorderPixel*3,y+CC.MenuBorderPixel*3+(size+4)*(i-1),strarray[i],color,size)
end
ShowScreen()--���������תΪ����
WaitKey()
lib.LoadSur(sid,x,y)
lib.FreeSur(sid)
ShowScreen()--���������תΪ����
end

--�����¼�
--eid �¼�id
--flag �¼�״̬
function SetFlag(eid,flag)
JY.Base["�¼�"..eid]=flag
end

--����¼�
--eid �¼�id
-->0�����棬���򷵻ؼ�
function GetFlag(eid)
if JY.Base["�¼�"..eid]>0 then
return true
else
return false
end
end

--�޸��佫AI
--pid �佫id
--ai 
function WarModifyAI(pid,ai,p1,p2)
pid=pid+1--����
local wid=GetWarID(pid)
if wid>0 then
War.Person[wid].ai=ai
if ai==3 or ai==5 then
War.Person[wid].aitarget=p1+1
elseif ai==4 or ai==6 then
War.Person[wid].ai_dx=p1+1
War.Person[wid].ai_dy=p2+1
end
end
end

--�޸��佫��Ӫ
--pid �佫id
--fid ��Ӫid��Ĭ��Ϊ1
function ModifyForce(pid,fid)
if pid==nil then
return
end
fid=fid or 1
--�޸��佫����ͳ��
if JY.Person[pid]["����"]==1 and fid~=1 then
JY.Base["�佫����"]=JY.Base["�佫����"]-1
end
if JY.Person[pid]["����"]~=1 and fid==1 then
JY.Base["�佫����"]=JY.Base["�佫����"]+1
end
--��������ҷ�������ȷ�ϵȼ�
if fid==1 then
JY.Person[pid]["�ȼ�"]=limitX(JY.Person[pid]["�ȼ�"],1,99)
if CC.Enhancement then
if JY.Status~=GAME_WMAP then
local dtlv=pjlv()
if JY.Person[pid]["�ȼ�"]<dtlv then--�¼�����佫����ȼ������ҷ�ƽ���ȼ������������ҷ�ƽ���ȼ�
JY.Person[pid]["�ȼ�"]=dtlv
end
end
end
end
JY.Person[pid]["����"]=fid
local picid=GetPic(pid)
if fid==1 and type(War.Person)=="table" then--ս��ʱ���������Ϊ����������Ҫ�����޸�ս����������
for i,v in pairs(War.Person) do
if v.id==pid then
v.enemy=false
v.friend=false
v.pic=WarGetPic(i)
v.ai=1
break
end
end
end
end

--�޸��佫����
--pid �佫id
--bzid ����id��Ĭ��Ϊ1
function ModifyBZ(pid,bzid)
if pid==nil then
return
end
bzid=bzid or 1
JY.Person[pid]["����"]=bzid
end

--��ʾ����ͼƬ�����߿򣩣������뵭��Ч��
--flag 0.��Ч�� 1.���� 2.����
function LoadPic(id,flag)
local w,h=238,158
local x=16+640/2-w/2
local y=16+64
flag=flag or 0
if between(id,3,33) then
DrawSMap()
local sid=lib.SaveSur(x,y,x+w,y+h)
if flag==0 then
lib.PicLoadCache(4,id*2,x,y,1)
elseif flag==1 then--����
for i=0,256,4 do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,x,y)
lib.PicLoadCache(4,id*2,x,y,1+2,i)
lib.GetKey()
ReFresh()
end
elseif flag==2 then--����
for i=0,256,4 do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,x,y)
lib.PicLoadCache(4,id*2,x,y,1+2,256-i)
lib.GetKey()
ReFresh()
end
end
lib.FreeSur(sid)
end
for i=1,CC.OpearteSpeed*2 do
JY.ReFreshTime=lib.GetTime()
lib.GetKey()
ReFresh()
end
end

function talk(...)
local arg={}
for i,v in pairs({...}) do
arg[i]=v
end
local n=math.modf(#arg/2)
local f=0
for i=0,n-1 do
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
WarPersonCenter(GetWarID(arg[i*2+1]))
f=2
end
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
else
JY.Tid=arg[i*2+1]
DrawSMap()
end
talk_sub(arg[i*2+1],arg[i*2+2],true,i%2+f)
JY.ReFreshTime=lib.GetTime()
ReFresh()
end
JY.Tid=0
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
else
DrawSMap()
end
end

function talkYesNo(id,s)
local x4=512
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=140
local y1=y2-24
JY.Tid=id
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
else
end
talk_sub(id,s)
JY.Tid=0
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
if flag==1 then
lib.PicLoadCache(4,52*2,x1,y1,1)
else
lib.PicLoadCache(4,51*2,x1,y1,1)
end
if flag==2 then
lib.PicLoadCache(4,54*2,x3,y1,1)
else
lib.PicLoadCache(4,53*2,x3,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
lib.FreeSur(sid)
return true
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
lib.FreeSur(sid)
return false
else
current=0
end
end
end

function talk_sub(id,s,pause,flag)
local talkxnum=19--�Ի�һ������
local talkynum=3--�Ի�����
pause=pause or false
flag=flag or 0
--��ʾͷ��ͶԻ�������
local mx,my=140,100
local xy={ [0]={headx=144,heady=60,
talkx=224,talky=80,
mx=144,my=60},
{headx=144,heady=292,
talkx=224,talky=312,
mx=144,my=292},
{headx=112,heady=76,
talkx=192,talky=96,
mx=112,my=76},
{headx=112,heady=340,
talkx=192,talky=360,
mx=112,my=340}, }
if string.find(s,"*")==nil then
s=GenTalkString(s,talkxnum)
end
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval)
end
local size=16
local headid=JY.Person[id]["ͷ�����"]
local startp=1
local endp
local dy=0
local sid
while true do
if dy==0 then
JY.ReFreshTime=lib.GetTime()
DrawYJZBox_sub(xy[flag].mx,xy[flag].my,384,80)
lib.PicLoadCache(2,headid*2,xy[flag].headx,xy[flag].heady,1)
DrawString(xy[flag].talkx,xy[flag].heady,JY.Person[id]["����"],C_Name,size)
end
endp=string.find(s,"*",startp)
if endp==nil then
DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp),M_White,size)
ReFresh()
if pause then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15)
end
while true do
local eventtype=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
lib.Delay(100)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15)
end
ReFresh()
end
end
break
else
DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp,endp-1),M_White,size)
end
dy=dy+1
startp=endp+1
if dy>=talkynum then
ReFresh()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15)
end
while true do
local eventtype=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
lib.Delay(100)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15)
end
ReFresh()
end
dy=0
end
end
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval)
end
end

function AddPerson(id,x,y,d)
table.insert(JY.Smap,{id,x,y,d,0})
end

function DecPerson(id)
for i,v in pairs(JY.Smap) do
if v[1]==id then
table.remove(JY.Smap,i)
break
end
end
end

function Person_Menu()
local menu={
{" �佫�鱨",nil,1},
{" ��������",nil,1},
{"�� ����",nil,1},
}
DrawYJZBox(32,32,"�佫",M_White,true)
 
local r=ShowMenu(menu,#menu,0,546,264,0,0,3,1,16,M_White,M_White)
if r==1 then
PersonStatus_Menu(1)
elseif r==2 then
ExchangeItem(1)
elseif r==3 then
if CC.Enhancement==false then
Maidan(1)
else
Maidan2(1)
end
end
end

function PersonStatus_Menu(fid)
local menu={}
local n=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==fid then
menu[i]={fillblank(JY.Person[i]["����"],11),PersonStatus,1}
n=n+1
else
menu[i]={"",nil,0}
end
end
DrawYJZBox(32,32,"�佫�鱨",M_White,true)
if n<=8 then
ShowMenu(menu,JY.PersonNum-1,8,546,224,0,0,5,1,16,M_White,M_White)
else
ShowMenu(menu,JY.PersonNum-1,8,530,224,0,0,6,1,16,M_White,M_White)
end
end

--�佫���Խ���
function PersonStatus(pid,x,y,flag)
flag=flag or 0
if type(x)=='number' and type(y)=='number' then
else
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-456)/2
y=32+(432-276)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-456)/2
y=16+(400-276)/2
else
x=(CC.ScreenW-456)/2
y=(CC.ScreenH-276)/2
end
end
local p=JY.Person[pid]
local close=false
if flag==0 then
DrawSMap()
DrawYJZBox(32,32,"�佫�鱨",M_White,true)
end
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
PersonStatus_sub(pid,x,y,flag)
if close then
lib.PicLoadCache(4,56*2,x+384,y+16,1)
else
lib.PicLoadCache(4,55*2,x+384,y+16,1)
end
ReFresh()
end
while true do
redraw()
local eventtype,keypress,mx,my=getkey()
if eventtype==3 and keypress==3 then
PlayWavE(1)
lib.Delay(20)
break
end
if MOUSE.HOLD(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
close=true
elseif MOUSE.CLICK(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
PlayWavE(0)
close=false
redraw()
lib.Delay(20)
break
else
close=false
end
for i=1,8 do
local iid=JY.Person[pid]["����"..i]
if iid>0 then
if MOUSE.CLICK(x+340,y+112+i*16,x+340+#JY.Item[iid]["����"]*16/2,y+112+(i+1)*16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--��ʾ��Ʒ����
end
end
end
for i,v in pairs({"����","����","����"}) do
local iid=JY.Person[pid][v]
if iid>0 then
if MOUSE.CLICK(x+184+16*4,y+183+i*21,x+184+16*4+#JY.Item[iid]["����"]*16/2,y+183+i*21+16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--��ʾ��Ʒ����
end
end
end
if MOUSE.CLICK(x+24,y+24,x+24+64,y+24+80) then
local name=p["����"]
if type(CC.LieZhuan[name])=='string' then
DrawLieZhuan(name)--��ʾ�д�
end
end
if MOUSE.CLICK(x+111,y+55,x+111+48,y+55+48) then
local bzkz="*���ƣ�"
for i=1,9 do
if JY.Bingzhong[p["����"]]["����"..i]>0 then
bzkz=bzkz..JY.Bingzhong[JY.Bingzhong[p["����"]]["����"..i]]["����"].." "
end
if i==9 and bzkz=="*���ƣ�" then
bzkz=""
end
end
DrawStrStatus("����Ӣ�ܱ��� - "..JY.Bingzhong[p["����"]]["����"],JY.Bingzhong[p["����"]]["˵��"]..bzkz)
end
if CC.Enhancement then
local box_w=36
local box_h=20
for i=1,6 do
local cx=x+56+box_w*((i-1)%3)
local cy=y+220+box_h*math.modf((i-1)/3)
if MOUSE.CLICK(cx+1,cy+1,cx+box_w,cy+box_h) then
if p["�ȼ�"]>=CC.SkillExp[p["�ɳ�"]][i] or flag==2 then
DrawSkillStatus(JY.Person[pid]["�ؼ�"..i])--��ʾ��������
end
end
end
end
end
lib.FreeSur(sid)
end

function PersonStatus_sub(pid,x,y,flag)
flag=flag or 0
x=x or 208
y=y or 72
ReSetAttrib(pid,false)
JY.Person[pid]["ս������"]=GetPic(pid,false,false)
lib.PicLoadCache(4,85*2,x,y,1)
local p=JY.Person[pid]
local b=JY.Bingzhong[p["����"]]
DrawString(x+135-#p["����"]*16/4,y+20,p["����"],M_White,16)
DrawString(x+184,y+20,p["�ȼ�"].."��".."��"..p["����"].."���� "..b["����"],M_White,16)
lib.Background(x+184-4,y+48,x+184+16*16+4,y+112,192)
if CC.Enhancement then
DrawStr(x+184,y+48+8,GenTalkString("�츳��"..JY.Skill[p["�츳"]]["����"].."*"..JY.Skill[p["�츳"]]["˵��"],16),M_White,16)
else
DrawStr(x+184,y+48+8,GenTalkString(b["˵��"],16),M_White,16)
end
lib.PicLoadCache(2,p["ͷ�����"]*2,x+24,y+24,1)
lib.PicLoadCache(1,(p["ս������"]+19)*2,x+111,y+55,1)
DrawString(x+184,y+120,"�� ������"..p["������"],M_White,16)
DrawString(x+184,y+141,"�������� "..p["����"],M_White,16)
DrawString(x+184,y+162,"�������� "..p["����"],M_White,16)
DrawString(x+184,y+183,"�ƶ���",M_White,16)
if b["�ƶ�"]==p["�ƶ�"] then
DrawString(x+184+16*4,y+183,"��"..b["�ƶ�"],M_White,16)
else
DrawString(x+184+16*4,y+183,string.format("%d(%+d)",p["�ƶ�"],p["�ƶ�"]-b["�ƶ�"]),M_White,16)
end
DrawString(x+184,y+204,"�� ��",M_White,16)
DrawString(x+184,y+225,"�� ��",M_White,16)
DrawString(x+184,y+246,"�� ��",M_White,16)
if p["����"]>0 then
DrawString(x+184+16*4,y+204,JY.Item[p["����"]]["����"],M_White,16)
end
if p["����"]>0 then
DrawString(x+184+16*4,y+225,JY.Item[p["����"]]["����"],M_White,16)
end
if p["����"]>0 then
DrawString(x+184+16*4,y+246,JY.Item[p["����"]]["����"],M_White,16)
end
local len=100
if CC.Enhancement then
for i,v in pairs({"����","����","ͳ��"}) do
local v1=p[v..'2']
local v2=p[v]
local color
if v1<30 then
color=210
elseif v1<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+87+i*32,x+44+len,y+87+10+i*32,M_Black)
lib.SetClip(x+44,y+87+i*32,x+44+len*v1/100,y+87+10+i*32)
lib.PicLoadCache(4,color*2,x+44,y+87+i*32,1)
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",v1)
DrawString2(x+44+60-16*#str/4,y+87-3+i*32,str,M_White,16)
if v1~=v2 then
str=string.format("(%+d)",v1-v2)
DrawString2(x+48+104,y+89-3+i*32,str,M_White,12)
end
end
else
for i,v in pairs({"����","����","ͳ��"}) do
local v1=p[v..'2']
local v2=p[v]
local color
if v1<30 then
color=210
elseif v1<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+95+i*32,x+44+len,y+95+10+i*32,M_Black)
lib.SetClip(x+44,y+95+i*32,x+44+len*v1/100,y+95+10+i*32)
lib.PicLoadCache(4,color*2,x+44,y+95+i*32,1)
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",v1)
DrawString2(x+44+60-16*#str/4,y+95-3+i*32,str,M_White,16)
if v1~=v2 then
str=string.format("(%+d)",v1-v2)
DrawString2(x+48+104,y+97-3+i*32,str,M_White,12)
end
end
end
if CC.Enhancement then
local wljy=p["��������"]
local zljy=p["��������"]
local tljy=p["ͳ�ʾ���"]
if p["����"]==100 then
wljy=200
elseif p["����"]==100 then
zljy=200
elseif p["ͳ��"]==100 then
tljy=200
end
local color
if wljy<30 then
color=210
elseif wljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+32,x+44+len,y+103+10+32,M_Black)
if wljy>1 then
lib.SetClip(x+44,y+103+32,x+44+len*wljy/200,y+103+10+32)
lib.PicLoadCache(4,color*2,x+44,y+103+32,1)
end
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",math.modf(wljy/2)).."��"
if wljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+32,str,M_White,16)
if zljy<30 then
color=210
elseif zljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+2*32,x+44+len,y+103+10+2*32,M_Black)
if zljy>1 then
lib.SetClip(x+44,y+103+2*32,x+44+len*zljy/200,y+103+10+2*32)
lib.PicLoadCache(4,color*2,x+44,y+103+2*32,1)
end
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",math.modf(zljy/2)).."��"
if zljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+2*32,str,M_White,16)
if tljy<30 then
color=210
elseif tljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+3*32,x+44+len,y+103+10+3*32,M_Black)
if tljy>1 then
lib.SetClip(x+44,y+103+3*32,x+44+len*tljy/200,y+103+10+3*32)
lib.PicLoadCache(4,color*2,x+44,y+103+3*32,1)
end
lib.SetClip(0,0,0,0)
local str
 str=string.format("%d",math.modf(tljy/2)).."��"
if tljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+3*32,str,M_White,16)
end
if CC.Enhancement then
DrawString(x+16,y+220,"����",M_White,16)
DrawSkillTable(pid,x+56,y+220,flag)
end
--����
for i=1,8 do
local tid=p["����"..i]
if tid>0 then
DrawString(x+340,y+112+i*16,JY.Item[tid]["����"],M_White,16)
else
if i==1 then
DrawString(x+340,y+112+i*16,"��Я��Ʒ",M_White,16)
end
break
end
end
end

-- ExchangeItem(fid)
-- ��������
-- fid,����id һ��Ӧ����1������
-- flag, ��ǣ���Ĭ��Ϊfalse�����Ϊtrue�����ж�����ʾ�����������𣿡�
function ExchangeItem(fid,flag)
fid=fid or 1
flag=flag or false
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=1
local current=1
local status=1--1ѡ���һ���� 2ѡ����� 3 ѡ��ڶ�����
local iid=0--ѡ�е�itemλ��
TeamSelect={id={},status={}}
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==fid then
ReSetAttrib(i,true)
JY.Person[i]["ս������"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
TeamSelect.status[num]=0--0δѡ�� 1ѡ��(��ȡ��) 2ѡ��(����ȡ��)
end
end
maxpage=math.modf((num-1)/6)+1
--------------------------------
-- ����������Ϣ
--------------------------------
local xy={
x1={},--���Ͻ�(�߿��ڣ�ʵ�ʲ���ͼ����ʾλ��)
y1={},
x2={},--����
y2={},
x3={},--����
y3={},
x4={},--���½�
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--��ǰ��ť
--------------------------------
--redraw()
--�ڲ��������ػ�
--frame ���ڿ��ƶ�����ʾ
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="��","������","�ָ���","�任��","����","����","����","�ָ���","����","����","����","����","����","��","��",}
local titlestr="���������佫�ĵ��ߣ���ѡ��"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["����"]
local hp=string.format("% 5d",JY.Person[pid]["������"])
local lv=string.format("% 5d",JY.Person[pid]["�ȼ�"])
local picid
if TeamSelect.status[idx]==0 then--δѡ��ʱ��Ϊ+19
picid=JY.Person[pid]["ս������"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["ս������"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
--ѡ������
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["ͷ�����"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["����"],136,JY.Person[cid]["����"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["����"]]["����"],24,JY.Bingzhong[JY.Person[cid]["����"]]["����"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["�ȼ�"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["ͳ��"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["����"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["����"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--����
for i=1,8 do
local tid=JY.Person[cid]["����"..i]
local color=M_White
if TeamSelect.status[current]==1 and i==iid then
color=M_DarkOrange
end
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["����"],color,16)
DrawString(562,176+i*18,"��"..kind[JY.Item[tid]["����"]],color,16)
else
if i==1 then
DrawString(466,176+i*18,"��Я��Ʒ��",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
Dark()
redraw()
Light()
if flag then
if not WarDrawStrBoxYesNo('����������',M_White,true) then
redraw()
return
end
end
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local eventtype,keypress=getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('����һ����',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) and status==1 then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("�������𣿡�",M_White,true) then
redraw()
if not flag then
Dark()
DrawSMap()
Light()
end
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
elseif eventtype==4 and keypress==3 then
if status==2 then
PlayWavE(1)
TeamSelect.status[current]=0
titlestr="���������佫�ĵ��ߣ���ѡ��"
iid=0
status=1
elseif status==3 then
PlayWavE(1)
titlestr="��ѡ��Ҫ�����ĵ��ߣ�"
iid=0
status=2
end
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
if status==1 then
current=idx
cid=TeamSelect.id[idx]
if JY.Person[cid]["����1"]==0 then
PlayWavE(2)
titlestr=JY.Person[cid]["����"].."ʲôҲû�У�"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="���������佫�ĵ��ߣ���ѡ��"
else
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="��ѡ��Ҫ�����ĵ��ߣ�"
status=2
end
elseif status==2 then
if TeamSelect.status[idx]==1 then
PlayWavE(1)
TeamSelect.status[idx]=0
titlestr="���������佫�ĵ��ߣ���ѡ��"
status=1
else
PlayWavE(2)
end
elseif status==3 then
local odx=current
current=idx
cid=TeamSelect.id[idx]
local oid=TeamSelect.id[odx]
local item=JY.Person[oid]["����"..iid]
if idx==odx then
--ʲô������
PlayWavE(2)
elseif JY.Person[cid]["����8"]>0 then
PlayWavE(2)
titlestr=JY.Person[cid]["����"].."�Ѳ����ٳ��е��ߣ�"
for n=1,20 do
redraw()
lib.GetKey()
end
current=odx
titlestr=JY.Item[item]["����"].."����˭��"
else
PlayWavE(0)
redraw()
if WarDrawStrBoxYesNo("����"..JY.Person[cid]["����"].."������",M_White,true) then
for n=iid,7 do
JY.Person[oid]["����"..n]=JY.Person[oid]["����"..(n+1)]
end
JY.Person[oid]["����8"]=0
for n=1,8 do
if JY.Person[cid]["����"..n]==0 then
JY.Person[cid]["����"..n]=item
break
end
end
titlestr="���������佫�ĵ��ߣ���ѡ��"
TeamSelect.status[odx]=0
iid=0
status=1
else
titlestr=JY.Item[item]["����"].."����˭��"
current=odx
end
end
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
 cid=TeamSelect.id[current]
local item=JY.Person[cid]["����"..i]
if item>0 then
if status==1 then
PlayWavE(0)
DrawItemStatus(item,cid)--��ʾ��Ʒ����
elseif status==2 then
PlayWavE(0)
iid=i
titlestr=JY.Item[item]["����"].."����˭��"
status=3
elseif status==3 then
if iid==i then
PlayWavE(1)
titlestr="��ѡ��Ҫ�����ĵ��ߣ�"
iid=0
status=2
else
PlayWavE(2)
end
end
end
break
end
end
end
end
end

-- �����佫
function HirePerson()
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=1
local current=1
TeamSelect={id={},status={}}
--�������佫����
local db={ "����","����","����","��׿",
"����","����","�Ƹ�","���",
"����","�����",
"����","���","����",
"�ܺ�","̫ʷ��",
"����","����","����","����","��˳","�¹�","����",
"������","����","�ĳ�","����","����","���","����","��ͼ","���","����",
"�µ�","����",
"����",
"����","��Խ","����","����",
"����","����","����","³��","���",
"���","����",
"����","��̩","½ѷ",
"����",
"����",
"����",
"����"}
local db2={ 23,66,23,66,
382,382,382,9999,
226,226,
144,144,144,
103,103,
176,176,176,176,176,226,9999,
513,348,348,324,324,324,324,324,348,348,
279,279,
568,
424,424,461,461,
513,513,592,592,9999,
630,630,
630,630,655,
513,
568,
568,
655}
local db3={
[4]=385,
[8]=386,
[12]=403,
[16]=404,
--[20]=405,
--[24]=388,
}
if JY.Base["�¼�333"]>=9 then
db2[8]=382--���
end
if JY.Base["�¼�333"]>=11 then
db2[22]=226--����
end
if JY.Base["�¼�333"]>=15 then
db2[44]=513--���
end
for i,v in pairs(db) do
local p1=JY.Person[420+i]
if p1["����"]==0 then
local p2=JY.Person[420]
for idx=1,JY.PersonNum-1 do
if JY.Person[idx]["����"]==v then
p2=JY.Person[idx]
break
end
end
for idx,par in pairs({"����","����","���","�Ա�","����","����","ͳ��","�츳","����","�ؼ�1","�ؼ�2","�ؼ�3","�ؼ�4","�ؼ�5","�ؼ�6"}) do
p1[par]=p2[par]
end
p1["�ɳ�"]=10
p1["�ȼ�"]=math.modf((JY.Person[1]["�ȼ�"]+JY.Person[2]["�ȼ�"]+JY.Person[3]["�ȼ�"]+JY.Person[54]["�ȼ�"]+JY.Person[126]["�ȼ�"])/6)-5
p1["�ȼ�"]=limitX(p1["�ȼ�"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if p1["�ȼ�"]<dtlv then
p1["�ȼ�"]=dtlv
end
end
if p2["��ͷ�����"]>0 then
p1["ͷ�����"]=p2["��ͷ�����"]
else
p1["ͷ�����"]=p2["ͷ�����"]
end
p1["��ͷ�����"]=db2[i]--��������� ���ٶ��ٹ�֮����ܼ���
end
end
for i=421,JY.PersonNum-1 do
if JY.Person[i]["ͷ�����"]>0 and JY.Person[i]["��ͷ�����"]<JY.EventID then
ReSetAttrib(i,true)
JY.Person[i]["ս������"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
if JY.Person[i]["����"]==1 then
TeamSelect.status[num]=1--0δѡ�� 1ѡ��
else
TeamSelect.status[num]=0
end
end
end
for i,v in pairs(db3) do
if JY.Base["�¼�333"]>=i then
ReSetAttrib(v,true)
JY.Person[v]["ս������"]=GetPic(v,false,false)
num=num+1
TeamSelect.id[num]=v
if JY.Person[v]["����"]==1 then
TeamSelect.status[num]=1--0δѡ�� 1ѡ��
else
JY.Person[v]["�ɳ�"]=10
JY.Person[v]["�ȼ�"]=math.modf((JY.Person[1]["�ȼ�"]+JY.Person[2]["�ȼ�"]+JY.Person[3]["�ȼ�"]+JY.Person[54]["�ȼ�"]+JY.Person[126]["�ȼ�"])/6)-5
JY.Person[v]["�ȼ�"]=limitX(JY.Person[v]["�ȼ�"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if JY.Person[v]["�ȼ�"]<dtlv then
JY.Person[v]["�ȼ�"]=dtlv
end
end
TeamSelect.status[num]=0
end
end
end
if num==0 then
WarDrawStrBoxConfirm("���޿��������佫��",M_White,true)
return
end
 maxpage=math.modf((num-1)/6)+1
--------------------------------
-- ����������Ϣ
--------------------------------
local xy={
x1={},--���Ͻ�(�߿��ڣ�ʵ�ʲ���ͼ����ʾλ��)
y1={},
x2={},--����
y2={},
x3={},--����
y3={},
x4={},--���½�
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--��ǰ��ť
local function GetPersonValue(pid)
--���������۸�
local p=JY.Person[pid]
local v=40000/(120-p["����"])+40000/(120-p["����"])+40000/(120-p["ͳ��"])
if p["����"]==14 then
v=v+200
elseif p["����"]==15 then
v=v+300
elseif p["����"]==16 then
v=v+1000
elseif p["����"]==17 then
v=v+400
elseif p["����"]>=20 then
v=v+800
end
if p["����"]=="����" then
v=v+1000
end
if p["����"]=="̫ʷ��" then
v=v+1000
end
if p["����"]=="³����" then
v=v+2000
end
if p["����"]=="����" then
v=v+1500
end
if p["����"]=="��ƽ" then
v=v+2500
end
if p["����"]=="����" then
v=v+3000
end
if p["����"]=="hnc" then
v=v+3000
end
if p["����"]=="����" then
v=v+4000
end
if p["����"]=="���" then
v=v+2500
end
v=100*math.modf(v/100)
v=limitX(v,500,10000)
v=math.modf(v/2)--���������۸�
return v
end
--------------------------------
--redraw()
-- �ڲ��������ػ�
-- frame ���ڿ��ƶ�����ʾ
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="��","������","�ָ���","�任��","����","����","����","�ָ���","����","����","����","����","����","��","��",}
local titlestr="���������佫����ѡ��"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["����"]
local hp=string.format("% 5d",JY.Person[pid]["������"])
local lv=string.format("% 5d",JY.Person[pid]["�ȼ�"])
local picid
if TeamSelect.status[idx]==0 then--δѡ��ʱ��Ϊ+19
picid=JY.Person[pid]["ս������"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["ս������"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
--ѡ������
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["ͷ�����"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["����"],136,JY.Person[cid]["����"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["����"]]["����"],24,JY.Bingzhong[JY.Person[cid]["����"]]["����"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["�ȼ�"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["ͳ��"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["����"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["����"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--����
for i=1,8 do
local tid=JY.Person[cid]["����"..i]
local color=M_White
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["����"],color,16)
DrawString(562,176+i*18,"��"..kind[JY.Item[tid]["����"]],color,16)
else
if i==1 then
DrawString(466,176+i*18,"��Я��Ʒ��",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
Dark()
redraw()
Light()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local eventtype,keypress=getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('����һ����',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("�������𣿡�",M_White,true) then
redraw()
Dark()
DrawSMap()
Light()
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
current=idx
cid=TeamSelect.id[idx]
if TeamSelect.status[idx]==0 then
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="����"..JY.Person[cid]["����"].."��"
redraw()
PersonStatus(cid,"","",2)
redraw()
local v=GetPersonValue(cid)
if WarDrawStrBoxYesNo("��"..v.."������"..JY.Person[cid]["����"].."������",M_White,true) then
redraw()
if v>JY.Base["�ƽ�"] then
PlayWavE(2)
TeamSelect.status[idx]=0
titlestr="�ƽ𲻹���"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="���������佫����ѡ��"
else
GetMoney(-v)
TeamSelect.status[idx]=1
ModifyForce(cid,1)
PlayWavE(11)
DrawStrBoxCenter(JY.Person[cid]["����"].."��Ϊ���£�")
end
else
TeamSelect.status[idx]=0
titlestr="���������佫����ѡ��"
end
else
PlayWavE(2)
titlestr=JY.Person[cid]["����"].."�Ѿ���Ϊ���£�"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="���������佫����ѡ��"
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
cid=TeamSelect.id[current]
local item=JY.Person[cid]["����"..i]
if item>0 then
PlayWavE(0)
DrawItemStatus(item,cid)--��ʾ��Ʒ����
end
break
end
end
end
end
end

-- ����ģʽ���䳡
function Maidan(fid)
fid=fid or 1
local m_pid={}
local m_eid={}
local num_pid,num_eid=0,0
local lv_max=math.modf((JY.Person[1]["�ȼ�"]+JY.Person[2]["�ȼ�"]+JY.Person[3]["�ȼ�"]+JY.Person[54]["�ȼ�"]+JY.Person[126]["�ȼ�"])/6)-5
lv_max=limitX(lv_max,1,99)
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==fid then
if JY.Person[i]["�ȼ�"]<lv_max then
num_pid=num_pid+1
m_pid[num_pid]=i
end
else
num_eid=num_eid+1
m_eid[num_eid]=i
end
end
if num_pid>0 and num_eid>10 then
talk(369,"����˭Ҫ���䣿")
local pid=FightSelectMenu(m_pid)
if pid<=0 then
talk(369,"��ô���´���˵�ɣ�")
return
end
local eid=m_eid[math.random(num_eid)]
talk(369,"��ô����ʼ�ɣ�")
local magic={}
for mid=1,JY.MagicNum-1 do
 magic[mid]=false
if HaveMagic(pid,mid) then
magic[mid]=true
end
end
local s={0,1,2,4,6}
if fight(pid,eid,s[math.random(5)])==1 then
talk(369,"�澫�ʣ�")
PlayWavE(11)
LvUp(pid)
JY.Person[pid]["����"]=0
DrawStrBoxCenter(JY.Person[pid]["����"].."�ĵȼ������ˣ�")
else
talk(369,"̫��ϧ�ˣ�")
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ��˴������飮")
JY.Person[pid]["����"]=JY.Person[pid]["����"]+30
if JY.Person[pid]["����"]>=100 then
PlayWavE(11)
LvUp(pid)
JY.Person[pid]["����"]=0
DrawStrBoxCenter(JY.Person[pid]["����"].."�ĵȼ������ˣ�")
end
end
else
talk(369,"û������Ҫ�����ˣ�")
end
end

-- �ݺ�ģʽ���䳡
function Maidan2(fid)
fid=fid or 1
local m_pid={}
local m_eid={}
local num_pid,num_eid=0,0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==0 then
if JY.Person[i]["����"]==fid then
num_pid=num_pid+1
m_pid[num_pid]=i
else
num_eid=num_eid+1
m_eid[num_eid]=i
end
end
end
if num_pid>0 and num_eid>10 then
talk(369,"����˭Ҫ���䣿")
local pid=FightSelectMenu(m_pid)
if pid<=0 then
talk(369,"��ô���´���˵�ɣ�")
return
end
local eid=m_eid[math.random(num_eid)]
talk(369,"��ô����ʼ�ɣ�")
local magic={}
for mid=1,JY.MagicNum-1 do
 magic[mid]=false
if HaveMagic(pid,mid) then
magic[mid]=true
end
end
local s={0,1,2,4,6}
if fight(pid,eid,s[math.random(5)])==1 then
talk(369,"�澫�ʣ�")
PlayWavE(11)
JY.Person[pid]["����"]=1
local exped=math.random(2)
if JY.Person[pid]["����"]==13 or JY.Person[pid]["����"]==16 or JY.Person[pid]["����"]==19 or JY.Person[pid]["����"]==26 then
if exped==1 and JY.Person[pid]["����"]<100 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]+10
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ��˴����������飮")
if JY.Person[pid]["��������"]>=200 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."��������",M_White)
JY.Person[pid]["����"]=JY.Person[pid]["����"]+1
end
elseif exped==2 and JY.Person[pid]["ͳ��"]<100 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]+10
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ��˴���ͳ�ʾ��飮")
if JY.Person[pid]["ͳ�ʾ���"]>=200 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."ͳ������",M_White)
JY.Person[pid]["ͳ��"]=JY.Person[pid]["ͳ��"]+1
end
end
else
if exped==1 and JY.Person[pid]["����"]<100 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]+10
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ��˴����������飮")
if JY.Person[pid]["��������"]>=200 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."��������",M_White)
JY.Person[pid]["����"]=JY.Person[pid]["����"]+1
end
elseif exped==2 and JY.Person[pid]["ͳ��"]<100 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]+10
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ��˴���ͳ�ʾ��飮")
if JY.Person[pid]["ͳ�ʾ���"]>=200 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."ͳ������",M_White)
JY.Person[pid]["ͳ��"]=JY.Person[pid]["ͳ��"]+1
end
end
end
else
talk(369,"̫��ϧ�ˣ�")
JY.Person[pid]["����"]=1
local exped=math.random(2)
if JY.Person[pid]["����"]==13 or JY.Person[pid]["����"]==16 or JY.Person[pid]["����"]==19 or JY.Person[pid]["����"]==26 then
if exped==1 and JY.Person[pid]["����"]<100 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]+5
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ���һЩ�������飮")
if JY.Person[pid]["��������"]>=200 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."��������",M_White)
JY.Person[pid]["����"]=JY.Person[pid]["����"]+1
end
elseif exped==2 and JY.Person[pid]["ͳ��"]<100 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]+5
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ���һЩͳ�ʾ��飮")
if JY.Person[pid]["ͳ�ʾ���"]>=200 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."ͳ������",M_White)
JY.Person[pid]["ͳ��"]=JY.Person[pid]["ͳ��"]+1
end
end
else
if exped==1 and JY.Person[pid]["����"]<100 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]+5
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ���һЩ�������飮")
if JY.Person[pid]["��������"]>=200 then
JY.Person[pid]["��������"]=JY.Person[pid]["��������"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."��������",M_White)
JY.Person[pid]["����"]=JY.Person[pid]["����"]+1
end
elseif exped==2 and JY.Person[pid]["ͳ��"]<100 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]+5
DrawStrBoxCenter(JY.Person[pid]["����"].."�õ���һЩͳ�ʾ��飮")
if JY.Person[pid]["ͳ�ʾ���"]>=200 then
JY.Person[pid]["ͳ�ʾ���"]=JY.Person[pid]["ͳ�ʾ���"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["����"].."ͳ������",M_White)
JY.Person[pid]["ͳ��"]=JY.Person[pid]["ͳ��"]+1
end
end
end
end
else
talk(369,"û������Ҫ�����ˣ�")
end
end

function Shop()
local sid=JY.Base["������"]
if sid<=0 then
PlayWavE(2)
WarDrawStrBoxConfirm("�˵�û�е����ݣ�",M_White,true)
return
end
local shopitem={
[1]={41,28,31},--��ˮ��֮սǰ,����
[2]={28,31,44},--���ι�֮ս��,��ƽ
[3]={28,31,53,41,38,35},--�Ŷ���֮ս��,�Ŷ�
[4]={28,31,53},--�㴨֮ս��,�㴨
--����֮սǰ,��ƽ/�Ŷ�
[5]={28,31,53,41,38,35,34},--����֮ս��,��ƽ/�Ŷ�/����,����ֻ���˱�����
[6]={28,31,53,50,47},--����I֮ս��,��ƽ/�Ŷ�/����/����/����������ֻ�е����ݵ�
--������ 31,32,50,47,34
[7]={20,22,24,26,41,38,35},--С��
[8]={20,22,24,26,28,29,31,53},--���I
[9]={31,32,50,47,34},--����
[10]={20,22,24,26,29,31,32,53},--��
[11]={41,38,39,35,44},--����
[12]={41,42,38,39,35,36},--����
[13]={20,22,24,26,29,32,53,34},--����I
[14]={42,39,36,44,45},--����I
--[15]={29,32,54,50,51,47},--����I
[15]={21,23,25,27,29,32,54,50,51,47},--����I,���ǵ���Ϸʵ��,��Ҫ�ڽ���,����������II,������II�Ĳ��ֵ���Ҳ�ӽ���
[16]={42,39,36,44,45,20,22,24},--����II
[17]={50,51,47,48,38,39},--��ɳ
[18]={21,23,25,27,29,42,39,36,34},--����II
[19]={21,23,25,27,29,30,32,54},--�ɶ�I
[20]={29,32,54,42,20,22,24,34},--��
[21]={21,23,25,27,29,30,32,33},--�ɶ�II
[22]={42,39,36,29,32,54,48,51},--����
[23]={42,39,40,36,37,48,51,52},--����II
[24]={21,23,25,27,43,30,33,55},--����III
[25]={30,33,55,43,40,37,45,46},--��
[26]={30,33,55,49,20,22,24,26},--���II
--[[
�������ܹ�����ߣ�
�����������飬�ƣ�����
��ƽ���ƣ�����Ũ���顣
�Ŷ����ƣ�������ҩ�������飬�����飬��ʯ�顣
�㴨���ƣ�������ҩ��
�������ƣ�������ҩ�������飬�����飬��ʯ�飬ը����
���ݣ��ƣ�������ҩ��ƽ���飬Ԯ���顣
������������ƽ���飬Ԯ���飬ը����
С�棺��ǹ�������������������񣬽����飬�����飬��ʯ�顣
���I����ǹ�������������������񣬾ƣ��ؼ��ƣ�������ҩ��
���II���Ͼƣ��ף��裬Ԯ���飬��ǹ�������������������� ����ʮ�˹أ����II֮ս��
������ǹ���������������������ؼ��ƣ���������ҩ��
���������飬�����飬�����飬��ʯ�飬Ũ���顣
���ϣ������飬�����飬�����飬�����飬��ʯ�飬ɽ���顣
����I����ǹ���������������������ؼ��ƣ�����ҩ��ը����
����II������������ʯ���������������徫�񣬻����飬�����飬ɽ���飬ը���� �ڶ�ʮ���أ�����֮ս��
����III������������ʯ���������������徫���ͻ��飬�Ͼƣ��ף��衣 ����ʮ���أ�����II֮ս��
����I�������飬�����飬ɽ���飬Ũ���飬�������顣
����II�������飬�����飬ɽ���飬Ũ���飬�������飬��ǹ������������ �ڶ�ʮ��أ�������֮ս��
����I���ؼ��ƣ�����ҩ��ƽ���飬�����飬Ԯ���顣
����II�������飬�����飬��Х�飬ɽ���飬ɽ���飬Ԯ���飬�����飬�����顣 ����ʮ�Źأ���֮ս��
��ɳ��ƽ���飬�����飬Ԯ���飬Ԯ���飬�����飬�����顣
�����ؼ��ƣ�����ҩ�������飬��ǹ������������ը����
�ɶ�I������������ʯ���������������徫���ؼ��ƣ��Ͼƣ�����ҩ��
�ɶ�II������������ʯ���������������徫���ؼ��ƣ��Ͼƣ����ס� ����ʮ�Źأ���֮ս��
���꣺�����飬�����飬ɽ���飬�ؼ��ƣ�����ҩ��Ԯ���飬�����顣
���Ͼƣ��ף��裬�ͻ��飬��Х�飬ɽ���飬�������飬�����顣
]]--
 }
local shopitem2={--������
[1]={74,80,89,140,147},--��ˮ��֮սǰ,����
[2]={74,75,80,89,99,140,141,147},--���ι�֮ս��,��ƽ
[3]={80,81,85,89,95,117,120,141,148},--�Ŷ���֮ս��,�Ŷ�
[4]={75,90,141,148},--�㴨֮ս��,�㴨
--����֮սǰ,��ƽ/�Ŷ�
[5]={80,81,85,89,95,117,120,141,148},--����֮ս��,��ƽ/�Ŷ�/����,����ֻ�����Ŷ���
[6]={90,96,120,125,126,131,142,148},--����I֮ս��,��ƽ/�Ŷ�/����/����/����������ֻ�е����ݵ�
--������ 31,32,50,47,34
[7]={81,85,100,117,135,142,152},--С��
[8]={86,90,101,104,105,117,135,142,152,148},--���I
[9]={86,90,101,105,142,152,148},--����,��ʵû�У����༸��
[10]={76,82,91,102,106,118,136,131,130},--��
[11]={140,141,142,147,148},--����,��ʵû�У����༸��
[12]={76,82,91,102,106,142},--����,��ʵû�У����༸��
[13]={91,97,127,131,141,143,152,149,150},--����I
[14]={76,82,86,106,109,110,118,121,123},--����I
[15]={103,107,111,114,132,133,142,144,153},--����I
[16]={76,82,86,106,109,110,118,121,123},--����II
[17]={76,82,86,103,107,110},--��ɳ,��ʵû�У����༸��
[18]={77,90,92,96,97,128},--����II
[19]={78,83,87,111,115,128,145,153,150},--�ɶ�I
[20]={92,97,102,106,139},--��,��ʵû�У����༸��
[21]={78,83,87,111,115,128,145,153,150},--�ɶ�II
[22]={78,83,87,92,97,102,106,111,115,139},--����,��ʵû�У����༸��
[23]={93,97,103,108,112,137,119,122,129},--����II
[24]={84,88,98,116,124,138,134,146,151},--����III
[25]={84,88,98,103,108},--��
[26]={79,94,113,139,132,154},--���II
}
local shopid=1--1���� 2����
local buysellmenu={
{"������� ",nil,1},
{"�������� ",nil,1},
{"������ ",nil,1},
}
local itemmenu={}
local itemnum=0
local personmenu={}
local personnum=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==1 then
personmenu[i]={fillblank(JY.Person[i]["����"],11),nil,1}
personnum=personnum+1
else
personmenu[i]={"",nil,0}
end
end
PlayWavE(0)
local status="SelectBuySell"
local iid,pid
local function showbuysellmenu()
talk_sub(375,"��ʲô���飿")
--��ӵ�����ѡ��
sid=JY.Base["������"]
if sid>1 then
local dm={"����","��ƽ","�Ŷ�","�㴨","��","����","С��","���I","��","��","��","��","����I","����I","����I","����II","��","����II","�ɶ�I","��","�ɶ�II","��","����II","����III","��","���II"}
local n={}
for i=1,sid do
if dm[i]=="��" then
n[i]={fillblank(dm[i],11),nil,0}
else
n[i]={fillblank(dm[i],11),nil,1}
end
end
local s=ShowMenu(n,#n,8,0,200,0,0,6,1,16,M_White,M_White)
if s>0 then
sid=s
end
end
local r=ShowMenu(buysellmenu,3,0,0,156,0,0,3,1,16,M_White,M_White)
if r==1 then
status="SelectItem"
shopid=1
itemmenu={}
itemnum=0
for i,v in pairs(shopitem[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["����"],11),nil,1}
end
elseif r==2 then
status="SelectItem"
shopid=2
itemmenu={}
itemnum=0
for i,v in pairs(shopitem2[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["����"],11),nil,1}
end
elseif r==3 then
status="SelectPersonSell"
else
status="Exit"
PlayWavE(1)
end
end
local function showitemmenu()
talk_sub(375,"��ʲô��")
local r=ShowMenu(itemmenu,itemnum,0,0,156,0,0,3,1,16,M_White,M_White)
if r>0 then
if shopid==1 then
iid=shopitem[sid][r]
elseif shopid==2 then
iid=shopitem2[sid][r]
else
iid=1
end
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Item[iid]["����"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Item[iid]["˵��"],18),M_White,size)
if talkYesNo(375,JY.Item[iid]["����"].."�ƽ�"..JY.Item[iid]["��ֵ"].."0��*������") then
--����ƽ𲻹�
if JY.Item[iid]["��ֵ"]*10>JY.Base["�ƽ�"] then
DrawSMap()
PlayWavE(2)
talk(375,"�����ƽ𲻹��ˣ�")
status="SelectItem"
else
status="SelectPerson"
end
end
else
status="SelectBuySell"
PlayWavE(1)
end
end
local function showpersonnum()
talk_sub(375,JY.Item[iid]["����"].."��λҪ��")
local r
if personnum<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
pid=r
if JY.Person[pid]["����8"]>0 then
PlayWavE(2)
if talkYesNo(375,"��λ������*�������ˣ����˰ɣ�") then
status="SelectPerson"
else
status="SelectItem"
end
else
PersonStatus_sub(pid,108,156)
if talkYesNo(375,"���Խ���"..JY.Person[pid]["����"].."��") then
GetMoney(-10*JY.Item[iid]["��ֵ"])
for i=1,8 do
if JY.Person[pid]["����"..i]==0 then
JY.Person[pid]["����"..i]=iid
break
end
end
DrawSMap()
DrawYJZBox(32,32,"��������",M_White,true)
if talkYesNo(375,"��л�ˣ���Ҫ�����������") then
status="SelectItem"
else
status="SelectBuySell"
end
else
status="SelectPerson"
end
end
else
status="SelectItem"
PlayWavE(1)
end
end
local function showpersonnumsell()
talk_sub(375,"������λ�Ķ�����")
local r
if personnum<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
pid=r
status="SelectItemSell"
else
status="SelectBuySell"
PlayWavE(1)
end
end
local function showitemmenusell()
if JY.Person[pid]["����1"]==0 then
PlayWavE(2)
talk(375,"��û��ʲô����������")
status="SelectPersonSell"
else
local sellmenu={}
for i=1,8 do
iid=JY.Person[pid]["����"..i]
if iid>0 then
sellmenu[i]={fillblank(JY.Item[iid]["����"],11),nil,1}
else
sellmenu[i]={"",nil,0}
end
end
talk_sub(375,"��ʲô��")
local rr=ShowMenu(sellmenu,8,0,0,156,0,0,3,1,16,M_White,M_White)
if rr>0 then
iid=JY.Person[pid]["����"..rr]
if talkYesNo(375,"��"..(10*math.modf(JY.Item[iid]["��ֵ"]*0.75)).."�ƽ��չ�"..JY.Item[iid]["����"].."��������") then
for i=rr,7 do
JY.Person[pid]["����"..i]=JY.Person[pid]["����"..(i+1)]
end
JY.Person[pid]["����8"]=0
GetMoney(10*math.modf(JY.Item[iid]["��ֵ"]*0.75))
DrawSMap()
DrawYJZBox(32,32,"��������",M_White,true)
if talkYesNo(375,"��л�ˣ���Ҫ����������ʲô��") then
status="SelectPersonSell"--?
status="SelectItemSell"--?
else
status="SelectBuySell"
end
else
status="SelectItemSell"
end
else
status="SelectPersonSell"
PlayWavE(1)
end
end
end
talk(375,"�������ˣ�")
while true do
JY.Tid=375
DrawSMap()
DrawYJZBox(32,32,"��������",M_White,true)
if status=="SelectBuySell" then
showbuysellmenu()
elseif status=="SelectItem" then
showitemmenu()
elseif status=="SelectPerson" then
showpersonnum()
elseif status=="SelectPersonSell" then
showpersonnumsell()
elseif status=="SelectItemSell" then
showitemmenusell()
else
talk(375,"��ӭ������")
break
end
end
end

function WarIni()
War={}
SetWarConst()
War.Person={}
War.PersonNum=0
Drama={}
end

--������ս����ʵ���ǰѵо�ɾ��
function WarIni2()
for i=War.PersonNum,1,-1 do
if War.Person[i].enemy then
table.remove(War.Person,i)
War.PersonNum=War.PersonNum-1
end
end
end

--ѡ���Ҿ�
--fid,����id һ��Ӧ����1������
--team,�Ҿ���ս��Ա��������,idΪ-1ʱ��ѡ��,����Ϊǿ�Ƴ�ս
function SelectTerm(fid,team)
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=0
local maxpersonnum=0
local current=1
for j=1,20 do
local idx=(j-1)*7
if team[idx+1]==-1 then
personnum=personnum+1
end
if team[idx+7]==nil then
break
end
maxpersonnum=j
end
if personnum==0 then
SelectTerm_sub(fid,team)
return
else
ExchangeItem(fid,true)
end
TeamSelect={id={},status={}}
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==fid then
ReSetAttrib(i,true)
JY.Person[i]["ս������"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
TeamSelect.status[num]=0--0δѡ�� 1ѡ��(��ȡ��) 2ѡ��(����ȡ��)
for j=1,maxpersonnum do
local idx=(j-1)*7
if team[idx+1]+1==i then
TeamSelect.status[num]=2
break
end
end
end
end
maxpage=math.modf((num-1)/6)+1
--------------------------------
-- ����������Ϣ
--------------------------------
local xy={
x1={},--���Ͻ�(�߿��ڣ�ʵ�ʲ���ͼ����ʾλ��)
y1={},
x2={},--����
y2={},
x3={},--����
y3={},
x4={},--���½�
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--��ǰ��ť
--------------------------------
--redraw()
-- �ڲ��������ػ�
-- frame ���ڿ��ƶ�����ʾ
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="��","������","�ָ���","�任��","����","����","����","�ָ���","����","����","����","����","����","��","��",}
local titlestr="�������佫�μ�ս����"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["����"]
local hp=string.format("% 5d",JY.Person[pid]["������"])
local lv=string.format("% 5d",JY.Person[pid]["�ȼ�"])
local picid
if TeamSelect.status[idx]==0 then--δѡ��ʱ��Ϊ+19
picid=JY.Person[pid]["ս������"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["ս������"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
DrawString(252,359,string.format("% 4d",personnum),M_White,16)
--ѡ������
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["ͷ�����"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["����"],136,JY.Person[cid]["����"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["����"]]["����"],24,JY.Bingzhong[JY.Person[cid]["����"]]["����"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["�ȼ�"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["ͳ��"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["����"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["����"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--����
for i=1,8 do
local tid=JY.Person[cid]["����"..i]
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["����"],M_White,16)
DrawString(562,176+i*18,"��"..kind[JY.Item[tid]["����"]],M_White,16)
else
if i==1 then
DrawString(466,176+i*18,"��Я��Ʒ��",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
redraw()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('������Ϸ��',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('����һ����',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("�����ϣ�������",M_White,true) then
local m,n=1,1
for i=1,20 do
local idx=(i-1)*7
if team[idx+1]==-1 then
m=i
break
end
end
for n=1,num do
if TeamSelect.status[n]==1 then
team[(m-1)*7+1]=TeamSelect.id[n]-1
m=m+1
end
end
SelectTerm_sub(fid,team)
Dark()
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
 current=idx
if TeamSelect.status[idx]==0 then
if personnum<=0 then
PlayWavE(2)
titlestr="�����ٲ�ս�ˣ�"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="�������佫�μ�ս����"
else
PlayWavE(0)
TeamSelect.status[idx]=1
personnum=personnum-1
end
elseif TeamSelect.status[idx]==1 then
PlayWavE(1)
TeamSelect.status[idx]=0
personnum=personnum+1
else
PlayWavE(2)
titlestr="���ܽ�������佫��"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="�������佫�μ�ս����"
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
cid=TeamSelect.id[current]
local item=JY.Person[cid]["����"..i]
if item>0 then
PlayWavE(0)
DrawItemStatus(item,cid)--��ʾ��Ʒ����
end
break
end
end
end
end
end

--ѡ���Ҿ���������սʱʹ��
--fid,����id һ��Ӧ����1������
--team,�Ҿ���ս��Ա��������,idΪ-1ʱ��ѡ��,����Ϊǿ�Ƴ�ս
function SelectTerm2(fid,team)
local num=0
local m,n=1,1
for i=1,JY.PersonNum-1 do
if JY.Person[i]["����"]==fid then
num=num+1
end
end
for i=1,20 do
local idx=(i-1)*7
if team[idx+1]==-1 then
m=i
break
end
end
for n=1,num do
if TeamSelect.status[n]==1 then
team[(m-1)*7+1]=TeamSelect.id[n]-1
m=m+1
end
end
for i=1,20 do
local idx=(i-1)*7
if team[idx+7]==nil then
break
end
if team[idx+1]>=0 and (team[idx+6]==-1 or GetFlag(team[idx+6])) then
--����+1�����޸�yjz���ݺ͸������ݵĲ�һ��
team[idx+1]=team[idx+1]+1
team[idx+2]=team[idx+2]+1
team[idx+3]=team[idx+3]+1
local wid=GetWarID(team[idx+1])
War.Person[wid].x=team[idx+2]
War.Person[wid].y=team[idx+3]
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=team[idx+4]
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if team[idx+7]>0 then
War.Person[War.PersonNum].hide=true
elseif War.Person[wid].live then
SetWarMap(team[idx+2],team[idx+3],2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end
end

--ѡ���Ҿ���������սʱʹ��
--fid,����id һ��Ӧ����1������
--team,�Ҿ���ս��Ա��������,�޸ĺ�İ汾
function SelectTerm2(fid,team)
for wid=1,War.PersonNum do
local idx=(wid-1)*7
if team[idx+7]==nil then
break
end
War.Person[wid].x=team[idx+2]+1
War.Person[wid].y=team[idx+3]+1
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=team[idx+4]
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if War.Person[wid].live then
SetWarMap(team[idx+2]+1,team[idx+3]+1,2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end

--ѡ���Ҿ�
--T,�Ҿ���ս��Ա��������
function SelectTerm_sub(fid,T)
for i=1,20 do
local idx=(i-1)*7
if T[idx+7]==nil then
break
end
if T[idx+1]>=0 and (T[idx+6]==-1 or GetFlag(T[idx+6])) then
--����+1�����޸�yjz���ݺ͸������ݵĲ�һ��
T[idx+1]=T[idx+1]+1
T[idx+2]=T[idx+2]+1
T[idx+3]=T[idx+3]+1
War.PersonNum=War.PersonNum+1
table.insert(War.Person, {
id=T[idx+1],--����ID
x=T[idx+2],--����X
y=T[idx+3],--����Y
--pic=JY.Person[T[idx+1]]["ս������"],--����ID
action=1,--���� 0��ֹ��1��·...
effect=0,--������ʾ
hurt=-1,--��ʾ�˺���ֵ
bz=JY.Person[T[idx+1]]["����"],
movewav=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["��Ч"],--�ƶ���Ч
atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["������Ч"],--������Ч
movestep=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["�ƶ�"],--�ƶ���Χ
movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["�ƶ��ٶ�"],--�ƶ��ٶ�
atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["������Χ"],--������Χ
sq_limited=100,
atk_buff=0,
def_buff=0,
frame=-1,--��ʾ֡��
d=T[idx+4],--����
active=true,--�ɷ��ж�
enemy=false,--�о��Ҿ�
friend=false,--�Ѿ���
ai=1,--AI����
live=true,--���
hide=false,--����
was_hide=false,--����
troubled=false,--����
leader=false,
})
if War.Leader1==T[idx+1] then
War.Person[War.PersonNum].leader=true
end
if JY.Person[T[idx+1]]["����"]~=fid then
War.Person[War.PersonNum].friend=true
end
if T[idx+7]>0 then
War.Person[War.PersonNum].hide=true
War.Person[War.PersonNum].was_hide=true
else
SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum)
end
ReSetAttrib(T[idx+1],true)
War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum)
end
end
if CC.Enhancement then
local lv_t={}
local cz=0
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["����"]==1 then
table.insert(lv_t,JY.Person[War.Person[i].id]["�ȼ�"])
cz=cz+1
end
end
table.sort(lv_t,function(a,b)return b<a end)
for ii=1,cz do
table.insert(lv_t,1)
end
local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end
lv=math.modf(lv/cz)--�õ��Ҿ�ƽ���ȼ�
if lv>=0 then
else--�����ȡ�ҷ���ս��Աƽ���ȼ�ʧ�ܣ��Ǿ�ֻ��һ�ֿ��ܣ�������ս
lv=pjlv()--��������ֻ�ܻ�ȡ�ҷ�ȫ����ƽ���ȼ�
end
CC.lv=lv
JY.Base["�Ҿ��ȼ�"]=CC.lv --�ѵȼ�д��r�����Ա����
end



end

--ѡ��о�
function SelectEnemy(T)
JY.Base["ȫ������"]=JY.EventID
local lvoffset=0
if CC.Enhancement then
local elv_sum=1
local num=0
for i=1,99 do
local idx=(i-1)*11
if T[idx+11]==nil then
break
end
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
elv_sum=elv_sum+T[idx+6]
num=num+1
end
end
local elv=math.modf(elv_sum/num)--ʵ�ʵо�ƽ���ȼ�
if CC.lv==nil then
CC.lv=JY.Base["�Ҿ��ȼ�"]
end
lvoffset=math.modf(limitX(CC.lv-elv+elv/10,0,99))--�õ��Ҿ�ƽ���ȼ��͵о�ƽ���ȼ��Ĳ�ֵ
end
for i=1,99 do
local idx=(i-1)*11
if T[idx+11]==nil then
break
end
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
--����+1�����޸�yjz���ݺ͸������ݵĲ�һ��
T[idx+1]=T[idx+1]+1
T[idx+2]=T[idx+2]+1
T[idx+3]=T[idx+3]+1
JY.Person[T[idx+1]]["�ȼ�"]=T[idx+6]+lvoffset
JY.Person[T[idx+1]]["����"]=T[idx+7]
War.PersonNum=War.PersonNum+1
War.EnemyNum=War.EnemyNum+1
table.insert(War.Person, {
id=T[idx+1],--����ID
x=T[idx+2],--����X
y=T[idx+3],--����Y
action=1,--���� 0��ֹ��1��·...
effect=0,--������ʾ
hurt=-1,--��ʾ�˺���ֵ
bz=JY.Person[T[idx+1]]["����"],
movewav=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["��Ч"],--�ƶ���Ч
atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["������Ч"],--������Ч
movestep=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["�ƶ�"],--�ƶ���Χ
movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["�ƶ��ٶ�"],--�ƶ��ٶ�
atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["����"]]["������Χ"],--������Χ
sq_limited=100,
atk_buff=0,
def_buff=0,
frame=-1,--��ʾ֡��
d=T[idx+4],--����
active=true,--�ɷ��ж�
enemy=true,--�о��Ҿ�
friend=false,--�Ѿ���
ai=T[idx+5],--AI����
aitarget=T[idx+8]+1,
ai_dx=T[idx+8]+1,
ai_dy=T[idx+9]+1,
live=true,--���
hide=false,--����
was_hide=false,--����
troubled=false,--����
leader=false,
})
if War.Leader2==T[idx+1] then
War.Person[War.PersonNum].leader=true
end
if T[idx+11]>0 then
War.Person[War.PersonNum].hide=true
War.Person[War.PersonNum].was_hide=true
else
SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum)
end
ReSetAttrib(T[idx+1],true)
War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum)
end
end
War.CX=limitX(War.Person[1].x-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(War.Person[1].y-math.modf(War.MD/2),1,War.Depth-War.MD+1)
--�����ݺ�ģʽ�µ��Ѿ��͵о��ȼ�
if CC.Enhancement then
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["����"]~=1 then
if JY.Person[War.Person[i].id]["�ȼ�"]<lvoffset-4 then
JY.Person[War.Person[i].id]["�ȼ�"]=JY.Person[War.Person[i].id]["�ȼ�"]+lvoffset
end
if War.Person[i].enemy then --�ݺ�ģʽ�£��о����յȼ��Զ���������
if JY.Person[War.Person[i].id]["�ȼ�"]>=15 then
if JY.Person[War.Person[i].id]["����"]==1 then
JY.Person[War.Person[i].id]["����"]=2
elseif JY.Person[War.Person[i].id]["����"]==4 then
JY.Person[War.Person[i].id]["����"]=5
elseif JY.Person[War.Person[i].id]["����"]==7 then
JY.Person[War.Person[i].id]["����"]=8
elseif JY.Person[War.Person[i].id]["����"]==10 then
JY.Person[War.Person[i].id]["����"]=11
elseif JY.Person[War.Person[i].id]["����"]==23 then
JY.Person[War.Person[i].id]["����"]=24
end
end
if JY.Person[War.Person[i].id]["�ȼ�"]>=30 then
if JY.Person[War.Person[i].id]["����"]==2 then
JY.Person[War.Person[i].id]["����"]=3
elseif JY.Person[War.Person[i].id]["����"]==5 then
JY.Person[War.Person[i].id]["����"]=6
elseif JY.Person[War.Person[i].id]["����"]==8 then
JY.Person[War.Person[i].id]["����"]=9
elseif JY.Person[War.Person[i].id]["����"]==11 then
JY.Person[War.Person[i].id]["����"]=12
elseif JY.Person[War.Person[i].id]["����"]==24 then
JY.Person[War.Person[i].id]["����"]=25
end
end
end
end
local id=i
local bzid=JY.Person[War.Person[id].id]["����"]
War.Person[id].bz=bzid
War.Person[id].movewav=JY.Bingzhong[bzid]["��Ч"]--�ƶ���Ч
War.Person[id].atkwav=JY.Bingzhong[bzid]["������Ч"]--������Ч
War.Person[id].movestep=JY.Bingzhong[bzid]["�ƶ�"]--�ƶ���Χ
War.Person[id].movespeed=JY.Bingzhong[bzid]["�ƶ��ٶ�"]--�ƶ��ٶ�
War.Person[id].atkfw=JY.Bingzhong[bzid]["������Χ"]--������Χ
War.Person[id].pic=WarGetPic(id)
ReSetAttrib(War.Person[i].id,true)--���¼���ս�����ԣ�
end
end
end

function DefineWarMap(id,warname,wartarget,maxturn,leader1,leader2)
War.MapID=id
War.WarName=warname
War.WarTarget=wartarget
War.MaxTurn=maxturn
War.Leader1=leader1+1
War.Leader2=leader2+1
LoadWarMap(War.MapID)
end

function WarStart()
JY.SubScene=-1
SRPG()
end

--����ս��
function WarSave(id)
Byte.set8(JY.Data_Base,136,War.MapID)
Byte.set8(JY.Data_Base,137,War.Width)
Byte.set8(JY.Data_Base,138,War.Depth)
Byte.set8(JY.Data_Base,139,War.CX)
Byte.set8(JY.Data_Base,140,War.CY)
Byte.set16(JY.Data_Base,141,War.PersonNum)
Byte.set8(JY.Data_Base,143,War.Weather)
Byte.set8(JY.Data_Base,144,War.Turn)
Byte.set8(JY.Data_Base,145,War.MaxTurn)
Byte.set16(JY.Data_Base,146,War.Leader1)
Byte.set16(JY.Data_Base,148,War.Leader2)
Byte.set8(JY.Data_Base,150,War.EnemyNum)
JY.Base["ս������"]=War.WarName
JY.Base["ս��Ŀ��"]=War.WarTarget
local offset=152
for i=1,War.PersonNum do
Byte.set16(JY.Data_Base,offset,War.Person[i].id)
Byte.set8(JY.Data_Base,offset+2,War.Person[i].x)
Byte.set8(JY.Data_Base,offset+3,War.Person[i].y)
Byte.set8(JY.Data_Base,offset+4,War.Person[i].d)
Byte.set8(JY.Data_Base,offset+5,War.Person[i].ai)
Byte.set16(JY.Data_Base,offset+6,War.Person[i].aitarget)
Byte.set8(JY.Data_Base,offset+8,War.Person[i].ai_dx)
Byte.set8(JY.Data_Base,offset+9,War.Person[i].ai_dy)
local v=0
if War.Person[i].enemy then
v=v+1
end
if War.Person[i].friend then
v=v+2
end
if War.Person[i].active then
v=v+4
end
if War.Person[i].live then
v=v+8
end
if War.Person[i].hide then
v=v+16
end
if War.Person[i].was_hide then
v=v+32
end
if War.Person[i].troubled then
v=v+64
end
Byte.set8(JY.Data_Base,offset+10,v)
offset=offset+11
end
--Map
offset=1152
for i=1,War.Width*War.Depth do
local v=War.Map[i]+32*War.Map[War.Width*War.Depth*(9-1)+i]
 Byte.set8(JY.Data_Base,offset+i,v)
end
--Save
SaveRecord(id)
end

--��ȡս��
function WarLoad(id)
WarIni()
--War basic informaction
War.MapID=Byte.get8(JY.Data_Base,136)
War.Width=Byte.get8(JY.Data_Base,137)
War.Depth=Byte.get8(JY.Data_Base,138)
War.CX=Byte.get8(JY.Data_Base,139)
War.CY=Byte.get8(JY.Data_Base,140)
War.PersonNum=Byte.get16(JY.Data_Base,141)
War.Weather=Byte.get8(JY.Data_Base,143)
War.Turn=Byte.get8(JY.Data_Base,144)
War.MaxTurn=Byte.get8(JY.Data_Base,145)
War.Leader1=Byte.get16(JY.Data_Base,146)
War.Leader2=Byte.get16(JY.Data_Base,148)
War.EnemyNum=Byte.get8(JY.Data_Base,150)
War.WarName=JY.Base["ս������"]
War.WarTarget=JY.Base["ս��Ŀ��"]
--Map
War.MiniMapCX=680-War.Width*2
War.MiniMapCY=411-War.Depth*2
War.Map={}
CleanWarMap(1,0)--����
CleanWarMap(2,0)--wid
CleanWarMap(3,0)--
CleanWarMap(4,1)--ѡ��Χ
CleanWarMap(5,-1)--������ֵ
CleanWarMap(6,-1)--���Լ�ֵ
CleanWarMap(7,0)--ѡ��Ĳ���
CleanWarMap(8,0)--AIǿ���ã��Ҿ��Ĺ�����Χ
CleanWarMap(9,0)--ˮ�����
CleanWarMap(10,0)--������Χ����ʾ��
local offset=1152
for i=1,War.Width*War.Depth do
local v=Byte.get8(JY.Data_Base,offset+i)
local v1=v%32
local v2=math.modf(v/32)
War.Map[i]=v1
War.Map[War.Width*War.Depth*(9-1)+i]=v2
end
--War.Person
offset=152
for i=1,War.PersonNum do
War.Person[i]={}
War.Person[i].id=Byte.get16(JY.Data_Base,offset)
War.Person[i].x=Byte.get8(JY.Data_Base,offset+2)
War.Person[i].y=Byte.get8(JY.Data_Base,offset+3)
War.Person[i].d=Byte.get8(JY.Data_Base,offset+4)
War.Person[i].ai=Byte.get8(JY.Data_Base,offset+5)
War.Person[i].aitarget=Byte.get16(JY.Data_Base,offset+6)
War.Person[i].ai_dx=Byte.get8(JY.Data_Base,offset+8)
War.Person[i].ai_dy=Byte.get8(JY.Data_Base,offset+9)
local v=Byte.get8(JY.Data_Base,offset+10)
if v%2==1 then
War.Person[i].enemy=true
else
War.Person[i].enemy=false
end
if (math.modf(v/2))%2==1 then
War.Person[i].friend=true
else
War.Person[i].friend=false
end
if (math.modf(v/4))%2==1 then
War.Person[i].active=true
else
War.Person[i].active=false
end
if (math.modf(v/8))%2==1 then
War.Person[i].live=true
else
War.Person[i].live=false
end
if (math.modf(v/16))%2==1 then
War.Person[i].hide=true
else
War.Person[i].hide=false
end
if (math.modf(v/32))%2==1 then
War.Person[i].was_hide=true
else
War.Person[i].was_hide=false
end
if (math.modf(v/64))%2==1 then
War.Person[i].troubled=true
else
War.Person[i].troubled=false
end
local pid=War.Person[i].id
War.Person[i].action=1--���� 0��ֹ��1��·...
War.Person[i].effect=0--������ʾ
War.Person[i].hurt=-1--��ʾ�˺���ֵ
War.Person[i].bz=JY.Person[pid]["����"]
War.Person[i].movewav=JY.Bingzhong[JY.Person[pid]["����"]]["��Ч"]--�ƶ���Ч
War.Person[i].atkwav=JY.Bingzhong[JY.Person[pid]["����"]]["������Ч"]--������Ч
War.Person[i].movestep=JY.Bingzhong[JY.Person[pid]["����"]]["�ƶ�"]--�ƶ���Χ
War.Person[i].movespeed=JY.Bingzhong[JY.Person[pid]["����"]]["�ƶ��ٶ�"]--�ƶ��ٶ�
War.Person[i].atkfw=JY.Bingzhong[JY.Person[pid]["����"]]["������Χ"]--������Χ
War.Person[i].sq_limited=100
War.Person[i].atk_buff=0
War.Person[i].def_buff=0
War.Person[i].frame=-1--��ʾ֡��
if pid==War.Leader1 or pid==War.Leader2 then
War.Person[i].leader=true
else
War.Person[i].leader=false
end
if War.Person[i].live and (not War.Person[i].hide) then
SetWarMap(War.Person[i].x,War.Person[i].y,2,i)
end
ReSetAttrib(pid,false)
War.Person[i].pic=WarGetPic(i)
WarResetStatus(i)
offset=offset+11
end
end

--��ʾ�Ƿ񱣴�
--flag, Ĭ��Ϊ1 1սǰ��ʾ 2ս����ʾ
function RemindSave(flag)
flag=flag or 1
if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_START--������Ϊ�˷����Զ���������
end
if WarDrawStrBoxYesNo("���ڴ�����",M_White,true) then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."δʹ�õ���"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"���������������",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("������Ӳ���ĵ�%d�ţ�������",s2),M_White,true) then
if flag==2 then
JY.Status=GAME_SMAP_AUTO--��ǰ���Ӧ���Ļ���
end
SaveRecord(s2)
end
end
end
if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_SMAP_AUTO--��ǰ���Ӧ���Ļ���
end
end

--�ȼ�����
--pid ����id, n Ĭ��Ϊ1
function LvUp(pid,n)
pid=pid or 0
n=n or 1
if pid>0 then
JY.Person[pid]["�ȼ�"]=limitX(JY.Person[pid]["�ȼ�"]+n,1,99)
end
end

--���Ե���ս������
--pid ����id, -1ʱΪ�����ҷ��佫
function WarCheckLocation(pid,y,x)
--pid=-1���������ҷ��ҽ�
pid=pid+1--����
x=x+1
y=y+1
if War.SelID==0 then
return false
end
local v=War.Person[War.SelID]
if v.live and (not v.hide) and ((pid==0 and (not v.enemy) and (not v.friend)) or pid==v.id) and x==v.x and y==v.y then
return true
end
return false
end

--���Ե���ս������õ���Ʒ
--x,y ����, item ��Ʒid, event ����¼�id
function WarLocationItem(y,x,item,event)
if War.SelID==0 then
return false
end
if JY.Person[War.Person[War.SelID].id]["����8"]>0 then
return false
end
x=x+1
y=y+1
if (not GetFlag(event)) then
local v=War.Person[War.SelID]
if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and x==v.x and y==v.y then
WarGetItem(War.SelID,item)
SetFlag(event,1)
end
end
end

--���Ե���ս������
--pid ����id, -1ʱΪ�����ҷ��佫
function WarCheckArea(pid,y1,x1,y2,x2)
--pid=-1���������ҷ��ҽ�
pid=pid+1--����
x1=x1+1
y1=y1+1
x2=x2+1
y2=y2+1
if War.SelID==0 then
return false
end
local v=War.Person[War.SelID]
if v.live and (not v.hide) and ((pid==0 and (not v.enemy)) or pid==v.id) and between(v.x,x1,x2) and between(v.y,y1,y2) then
return true
end
return false
end

function GetWarID(pid)
for i,v in pairs(War.Person) do
if pid==v.id then
return i
end
end
return 0
end

function WarMeet(pid1,pid2)
local id1,id2=0,0
if War.SelID==0 then
return false
end
if pid1==-1 then--���޶��ص�����
if War.Person[War.SelID].enemy then--���벻Ϊ�о�
return false
else
id1=War.SelID
pid1=War.Person[War.SelID].id
end
elseif War.Person[War.SelID].id==pid1 then--ָ������ ����Ϊ��ǰ�ж�����
id1=War.SelID
else
return false
end
id2=GetWarID(pid2)
if id1>0 and id2>0 and
War.Person[id1].live and War.Person[id2].live and 
(not War.Person[id1].hide) and (not War.Person[id2].hide) and 
JY.Person[pid1]["����"]>0 and JY.Person[pid2]["����"]>0 then
if math.abs(War.Person[id1].x-War.Person[id2].x)+math.abs(War.Person[id1].y-War.Person[id2].y)==1 then
return true
end
end
return false
end

-- �����ƶ���ָ������
-- pid ����id
function WarMoveTo(pid,x,y)
x=x+1
y=y+1
local wid=GetWarID(pid)
if wid>0 then
War.SelID=wid
War_CalMoveStep(wid,256,true)
x,y=WarGetExistXY(x,y,wid)
War_MovePerson(x,y)
CleanWarMap(4,1)
War.LastID=War.SelID
War.SelID=0
end
end

-- ��������
-- pid ����id
function WarShowArmy(pid)
pid=pid+1--����id
local wid=GetWarID(pid)
if wid>0 then
if (not War.Person[wid].hide) or (not War.Person[wid].live) then
return
end
local x,y=War.Person[wid].x,War.Person[wid].y
if WarCanExistXY(x,y,wid) then
War.Person[wid].hide=false
WarPersonCenter(wid)
SetWarMap(x,y,2,wid)
PlayWavE(15)
WarDelay(4)
return
end
local DX={0,0,-1,1}
local DY={1,-1,0,0}
local dx={1,-1,1,-1,}
local dy={-1,1,1,-1}
for n=1,8 do
for d=1,4 do
for i=1,n do
local nx=x+DX[d]*n+dx[d]*i
local ny=y+DY[d]*n+dy[d]*i
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
if WarCanExistXY(nx,ny,wid) then
War.Person[wid].x=nx
War.Person[wid].y=ny
War.Person[wid].hide=false
WarPersonCenter(wid)
SetWarMap(nx,ny,2,wid)
PlayWavE(15)
WarDelay(4)
return
end
end
end
end
end
end
end

--Ѱ������Ŀ��Գ��ֵĵص�
--x,yĿ��ص�
--widս������id
function WarGetExistXY(x,y,wid)
local DX={0,0,-1,1}
local DY={1,-1,0,0}
local dx={1,-1,1,-1,}
local dy={-1,1,1,-1}
if WarCanExistXY(x,y,wid) then
return x,y
end
for n=1,8 do
for d=1,4 do
for i=1,n do
local nx=x+DX[d]*n+dx[d]*i
local ny=y+DY[d]*n+dy[d]*i
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
if WarCanExistXY(nx,ny,wid) then
return nx,ny
end
end
end
end
end
return War.Person[wid].x,War.Person[wid].y
end

--��ûƽ�
--money �ƽ�����,Ϊ����ʱʧȥ�ƽ�����ʾ
function GetMoney(money)
JY.Base["�ƽ�"]=limitX(JY.Base["�ƽ�"]+money,0,50000)
end

--��õ���
--pid ����id
function GetItem(pid,item)
for i=1,8 do
if JY.Person[pid]["����"..i]==0 then
JY.Person[pid]["����"..i]=item
PlayWavE(11)
DrawStrBoxWaitKey("���"..JY.Item[item]["����"].."��",M_White)
return true
end
end
return false
end

--��õ���
--wid ����wid
function WarGetItem(wid,item)
local pid=War.Person[wid].id
for i=1,8 do
if JY.Person[pid]["����"..i]==0 then
JY.Person[pid]["����"..i]=item
PlayWavE(11)
WarDrawStrBoxWaitKey("���"..JY.Item[item]["����"].."��",M_White)
ReSetAttrib(pid,false)
return true
end
end
return false
end

--ʧȥ����
--wid ����wid
function WarLoseItem(wid,item)
local pid=War.Person[wid].id
for i=1,8 do
if JY.Person[pid]["����"..i]==0 then
JY.Person[pid]["����"..i]=item
PlayWavE(11)
WarDrawStrBoxWaitKey("���"..JY.Item[item]["����"].."��",M_White)
ReSetAttrib(pid,false)
return true
end
end
return false
end

--�д沿�ӵõ�50�㾭��ֵ��
--Exp ����ֵ,����
function WarGetExp(Exp)
Exp=50
PlayWavE(0)
lib.GetKey()
local x,y
local w=288
local h=80
x=16+576/2-w/2
y=32+432/2-h/2
local x1=x+205
local y1=y+36
local x2=x1+52
local y2=y1+24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
lib.PicLoadCache(4,84*2,x,y,1)
if flag==2 then
lib.PicLoadCache(4,56*2,x1,y1,1)
else
lib.PicLoadCache(4,55*2,x1,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
WarDelay(4)
break
else
current=0
end
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if (not v.enemy) and (not v.friend) then
local pid=v.id
if JY.Person[pid]["�ȼ�"]<99 then
JY.Person[pid]["����"]=JY.Person[pid]["����"]+Exp
if JY.Person[pid]["����"]>=100 then
JY.Person[pid]["����"]=JY.Person[pid]["����"]-100
WarLvUp(i)
end
end
end
end
end
end

--�ж��Ƿ�������״̬
--wid war_id
--4.�������Ƿ���������
--���ǣ�ƺ󣬷�������ʿ���½���30���£��������㷨�ж��Ƿ��������ҡ�
--�����һ��0��4֮������������������С��3�������������������ҡ�
--��˵������������60���Ŀ�����������ҡ�
function WarGetTrouble(wid)
local pid=War.Person[wid].id
if JY.Person[pid]["ʿ��"]<30 and JY.Person[pid]["����"]>0 then
if math.random(5)-1<3 then
if War.Person[wid].troubled then
WarDrawStrBoxDelay(JY.Person[pid]["����"].."���ӻ����ˣ�",M_White)
else
War.Person[wid].troubled=true
War.Person[wid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[pid]["����"].."�����ˣ�",M_White)
end
end
end
end

--���ѻ����еĲ���
--wid war_id
--�ָ����ӣ�0��99�������������ָ�����С�ڣ�ͳ������ʿ������3����ô���ӱ����ѣ��ɴ˿�����ͳ��Խ�ߣ�ʿ��Խ�ߣ�Խ���״ӻ��������ѣ�
function WarTroubleShooting(wid)
local pid=War.Person[wid].id
if War.Person[wid].troubled then
local flag=false
if math.random(100)-1<(JY.Person[pid]["ͳ��"]+JY.Person[pid]["ʿ��"])/3 then
flag=true
end
if CC.Enhancement then
if WarCheckSkill(wid,20) then--����
flag=true
end
end
if flag then
WarPersonCenter(wid)
War.Person[wid].troubled=false
WarDrawStrBoxDelay(JY.Person[pid]["����"].."�ӻ����лָ���",M_White)
end
end
end

--����ʿ������
--id 1�Ҿ� 2�о�
--kind 1���� 2ʿ��
function WarEnemyWeak(id,kind)
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if (id==1 and (not v.enemy)) or (id==2 and v.enemy) then
local pid=v.id
if kind==1 then
JY.Person[pid]["����"]=limitX(JY.Person[pid]["����"]/2,1,JY.Person[pid]["������"])
elseif kind==2 then
JY.Person[pid]["ʿ��"]=limitX(JY.Person[pid]["ʿ��"]/2,1,v.sq_limited)
ReSetAttrib(pid,false)
WarGetTrouble(i)
end
end
end
end
end

--ˮ�����
--x,y����,����Ϊdos�����꣬ʵ����Ҫ+1����
--kind 1�Ż� 2��ˮ 3ȡ����ˮ
function WarFireWater(x,y,kind)
x=x+1
y=y+1
if kind==3 then
SetWarMap(x,y,9,0)
else
if GetWarMap(x,y,2)==0 then
SetWarMap(x,y,9,kind)
end
if kind==1 then
elseif kind==2 then
end
end
War.CX=limitX(x-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(y-math.modf(War.MD/2),1,War.Depth-War.MD+1)
WarDelay(CC.WarDelay)
end

--����Ƿ����ĳ���
--wid ����ս�����
--skillid ���ܱ��
function WarCheckSkill(wid,skillid)
local pid=War.Person[wid].id
if JY.Person[pid]["�츳"]==skillid then
return true
end
if JY.Person[pid]["����"]==JY.Item[JY.Person[pid]["����"]]["ר���ؼ���"] and JY.Item[JY.Person[pid]["����"]]["ר���ؼ�"]==skillid then
return true
end
if JY.Item[JY.Person[pid]["����"]]["�ؼ�"]==skillid then
return true
end
for i=1,6 do
if JY.Person[pid]["�ؼ�"..i]==skillid then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][i] then
return true
end
end
end
return false
end

function CheckSkill(pid,skillid)
if pid<=0 then
return false
end
if JY.Person[pid]["�츳"]==skillid then
return true
end
for i=1,6 do
if JY.Person[pid]["�ؼ�"..i]==skillid then
if JY.Person[pid]["�ȼ�"]>=CC.SkillExp[JY.Person[pid]["�ɳ�"]][i] then
return true
end
end
end
return false
end

--ԭfight.lua
function fight(id1,id2,sid)
if JY.Status==GAME_START or JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
Dark()
if CC.ScreenW~=CONFIG.Width2 or CC.ScreenH~=CONFIG.Height2 then
CC.ScreenW=CONFIG.Width2
CC.ScreenH=CONFIG.Height2
Config()
PicCatchIni()
end
elseif JY.Status==GAME_WMAP or JY.Status==GAME_DEAD or JY.Status==GAME_END then
Dark()
end
if sid==nil then
if JY.Status==GAME_WMAP then
local wid=GetWarID(id2)
sid=GetWarMap(War.Person[wid].x,War.Person[wid].y,1)
else
local s={0,1,2,4,6}
sid=s[math.random(5)]
end
end
local r=fight_sub(id1,id2,sid)
Dark()
if JY.Status==GAME_START then
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
if CC.ScreenW~=CONFIG.Width or CC.ScreenH~=CONFIG.Height then
CC.ScreenW=CONFIG.Width
CC.ScreenH=CONFIG.Height
Config()
PicCatchIni()
end
DrawSMap()
Light()
elseif JY.Status==GAME_WMAP then
DrawWarMap()
Light()
elseif JY.Status==GAME_DEAD then
elseif JY.Status==GAME_END then
end
return r
end

function fight_sub(id1,id2,sid)
local n=2
local ID={id1,id2}
local p1,p2=JY.Person[id1],JY.Person[id2]
local fightname=fillblank(p1["����"],12).."ս"..fillblank(p2["����"],12)
local card={[1]={},[2]={}}
local card_num={}
local str={
[1]={ "%s�ڴˣ�*��������ͨ��������", "����%s��Ҳ��*ȫ��һս�ɣ�",
"����%sҲ��*����ͨ����ս��", "%s�ڴˣ�*��������ɣ�",
"%s���ˣ�*����ս��������������", "%s�ڴˣ�*�������ɣ�",
"����%s��*�������²�ն����֮��", "%s�ڴˣ�*���ҿ��㵽���ж�����",
"����%sҲ��*˭��һս��", "�ü��ˣ�*%s���������ս��",
"��Ȼ���˸���ս��%s��", "��˵���棡*���аɣ�",
"%s�ڴˣ�*�в�Ҫ���ĸ�������", "��%s��������ġ�*���ɣ����У�",
"����%sҲ��*���ձض�ն��������", "%s�ڴˣ�*����һ�н���㣡",
"%s�ڴˣ�*��һ�°ɣ�", "%s�ڴˣ�*����һ�н���㣡",
"��%s���ˣ�*����������һ����", "����˼��*��%s�������㣡",
"����%s��*�н�������ȡ��������ͷ�ˣ�", "�ߡ�����С����*������",
"����%s��*�������֪��ߵغ�Ļ쵰��*�챨��������", "˵ʲô������*����%s�������ɣ�",
"%s�ڴˣ�*����һ��ʤ���ɣ�", "��������*�ã����������",
"��������%s�����հɣ�", "���ɣ�*%s������㣡",
"��������%s���㵹ù��*���������������������ڣ�", "�����Ц������˼��*������ô��������Դ���",},
[2]={"ѽ~ѽ~ѽ~ѽ~ѽ������","�����У�","���ù�ȥ��","С���ˣ�","ɱ������",
"���жԸ��㣬�㹻�ˣ�","����ȡ�㹷����","�����������ˣ�","����ɣ�","ȥ����",},
[3]={"��һ�У���ϸ������ɣ�","���ɣ�*�����������ҵ��ٶȣ�","���ǻ����ˣ�*���������аɣ�","ֻ�����������*�ǿɲ���Ŷ��","���ɣ�*��ֵ����ʹ����һ�У�",
"��û���أ�������","����������*һ�е�׼������Ϊ����һ�У�","......*����","�������ҵļҴ������ɣ�","��һ�У�*��Ȼ������������*���ǻ�����´����࣡",
"�����ͣ�*�����ӵ�ס����һ���𣬿��У�","�����ร�*�������ˣ�*����������ˣ�","���Ѿ��군�ˣ�*�����ʶ�������ľ��У�*�͵������»�Ȫ������ɣ�","��������*̫���ˣ�̫���ˣ�","���������ϵ��ˣ�*�������У�",},
[4]={"�ߣ�","����","��Ȼ��һ��","��������","�ô��������",
"�ÿ���ٶȣ�","��һ*�ǹ�����","��û�뵽......","����������...","��Ȼû��ס��",
"�ɡ��ɶ�...","�۰�������......��","������ô����...","��ѽ��*�㡢���ˣ�","����",},
[5]={"������ˣ�","���գ�","������ʵ��","�����㼼����","��Ҳ����ʽ��",
"�㻹����������","����������һ��","���ҷ����ˣ�","�����и�����û�����죡","����������*һ��о���û�У�",
"��ô����*���ֻ���������ӣ�","��ƾ������գ�*����ʤ�ң�","��ô����*�����������","���ֵ��С��������ǰ��*�������ǰ���Ū����","������˼��*���Զ�����ȫû�á�",},
[6]={"��Ȼ����...","�Ҳ�����������...","��ô��������","���ú������...","��һ�̫�ֲ��ˣ�",
"�벻���һ��������...","��Ҫ������","���裡","��֣�*����...��ôû������?","�ٲ������������ˣ�",
"���������ϣ�*���޻���˵��","����Ȼ������","������Һ���֮��Ĳ����......","...*......","����֮��*��Ȼ�������ǿ���Ķ��֣�",},
[7]={"�н����һ����ˣ�","����������*�����˸�����","����һ����","��ʹ�죡","�����ɣ�",
"֪�������˰�!","���Ӯ�ˣ�*��û����أ�","Ӯ��","����Ƿ������³���","̫���ˣ�",},
}
card_num[1]=5+p1["����"]
card_num[2]=5+p2["����"]
local hpmax={150+p1["�ȼ�"],150+p2["�ȼ�"]}
local hp={150+p1["�ȼ�"],150+p2["�ȼ�"]}
local mp={20,20}
if p1["����"]>p2["����"] then
mp[1]=35
elseif p1["����"]<p2["����"] then
mp[2]=35
end
local atk={math.max(math.modf(p1["����"]/10)-1,2),math.max(math.modf(p2["����"]/10)-1,2)}
if atk[1]-atk[2]>5 then
atk[2]=atk[1]-5
elseif atk[2]-atk[1]>5 then
atk[1]=atk[2]-5
end
local atk_offset=8/math.max(atk[1],atk[2])
atk[1]=math.modf(atk[1]*atk_offset)
atk[2]=math.modf(atk[2]*atk_offset)
atk[1]=atk[1]+math.modf(p1["��ս"]/8)-p2["��ս"]%8
atk[2]=atk[2]+math.modf(p2["��ս"]/8)-p1["��ս"]%8
if p1["ʿ��"]<80 then
atk[1]=atk[1]-1
end
if p1["ʿ��"]<30 then
atk[1]=atk[1]-1
end
if p2["ʿ��"]<80 then
atk[2]=atk[2]-1
end
if p2["ʿ��"]<30 then
atk[2]=atk[2]-1
end
if atk[1]<2 then
atk[1]=2
end
if atk[2]<2 then
atk[2]=2
end
if JY.Status==GAME_WMAP then
end
local s={}
s[1]={
d=0,--0123 ��������
x=96,
pic=p1["ս������"],
action=9,--0��ֹ 1�ƶ� 2���� 3���� 4������ 5���� 9������
frame=0,
effect=0,
mpadd=6+4*p1["ŭ��"]+p1["����"]/2+math.max(0,p1["ʿ��"]/10-8),
luck=math.min(30,p1["����"]+p1["�侲"]*3+10*p1["ǿ��"])+10*p1["ǿ��"],
movewav=JY.Bingzhong[p1["����"]]["��Ч"],
atkbuff=JY.Bingzhong[p1["����"]]["����"]/2,
defbuff=JY.Bingzhong[p1["����"]]["����"]/2,
ym=p1["����"],
lj=p1["�侲"],
lv=p1["�ȼ�"],
loser=false,
dl=p1["����"],--�����ɷ�ʹ��
jj=p1["����"],--���ȿɷ�ʹ��
bq=p1["����"],--����������˺����ޣ��������˺�
txt="",
}
s[2]={
d=0,
x=576,
pic=p2["ս������"],
action=9,--0��ֹ 1�ƶ� 2���� 3���� 4������ 5���� 6���� 9������
frame=0,
effect=0,
mpadd=6+4*p2["ŭ��"]+p2["����"]/2+math.max(0,p2["ʿ��"]/10-8),
luck=math.min(30,p2["����"]+p2["�侲"]*3+10*p2["ǿ��"])+10*p2["ǿ��"],
movewav=JY.Bingzhong[p2["����"]]["��Ч"],
atkbuff=JY.Bingzhong[p2["����"]]["����"]/2,
defbuff=JY.Bingzhong[p2["����"]]["����"]/2,
ym=p2["����"],
lj=p2["�侲"],
lv=p2["�ȼ�"],
dz=math.random(math.modf(p2["ʿ��"]/2+1),p2["ʿ��"]+3),
loser=false,
dl=p2["����"],
jj=p2["����"],--���ȿɷ�ʹ��
bq=p2["����"],--����������˺����ޣ��������˺�
txt="",
}
s[1].ym=limitX(s[1].ym,0,math.modf(p1["ʿ��"]/14))
s[1].lj=limitX(s[1].lj,0,math.modf(p1["ʿ��"]/14))
s[2].ym=limitX(s[2].ym,0,math.modf(p2["ʿ��"]/14))
s[2].lj=limitX(s[2].lj,0,math.modf(p2["ʿ��"]/14))
local size=48*2
local size2=64*2
local sy=256
local pic1=0
local pic2=10
--00 ƽԭ 01 ɭ�� 02 ɽ�� 03 ���� 04 ���� 05 ��ǽ 06 �ǳ� 07 ��ԭ
--08 ��ׯ 09 ���� 0A ���� 0B �ĵ� 0C դ�� 0D ¹�� 0E ��Ӫ 0F ����
--10 ����� 11 ���� 12 ���� 13 ����
if sid==0 or sid==7 then
pic1=4
pic2=12
elseif sid==2 or sid==11 then
pic1=0
pic2=13
elseif sid==1 then
pic1=3
pic2=12
elseif sid==4 then
pic1=1
pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
pic1=2
pic2=10
end
local function admp(i,v)
v=math.modf(v)
mp[i]=limitX(mp[i]+v,0,100)
end
local function dechp(i,v,flag)--flag �񵲳ɹ�
flag=flag or false
if math.random(100)<s[3-i].atkbuff then
v=v+1
end
if math.random(100)<s[i].defbuff then
v=v-1
end
v=math.modf(v)
if v<1 then
v=1
end
if flag and s[i].bq>0 then
v=0
end
hp[i]=hp[i]-v
if hp[i]<0 then
hp[i]=0
end
--������ʱmp����
admp(i,1+v/2)
end
local function show()
getkey()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(1,pic2*2,-408,212,1)
lib.PicLoadCache(1,pic1*2,-168,92,1)
DrawBox(84,101,152,185,M_White)
lib.PicLoadCache(2,p1["ͷ�����"]*2,86,103,1)
if s[1].losser then
lib.Background(86,103,86+64,103+80,106)
end
DrawBox(154,163,222,185,M_White)
DrawBox(224,163,292,185,M_White)
DrawString(188-#p1["����"]*4,166,p1["����"],M_White,16)
DrawString(226,166,string.format("���� %3d",p1["����"]),M_White,16)
DrawStrBox(166,101,s[1].txt,M_White,16)
DrawBox(616,101,684,185,M_White)
lib.PicLoadCache(2,p2["ͷ�����"]*2,618,103,1)
if s[2].losser then
lib.Background(618,103,618+64,103+80,106)
end
DrawBox(546,163,614,185,M_White)
DrawBox(476,163,544,185,M_White)
DrawString(580-#p2["����"]*4,166,p2["����"],M_White,16)
DrawString(478,166,string.format("���� %3d",p2["����"]),M_White,16)
DrawStrBox(-162,101,s[2].txt,M_White,16)
lib.FillColor(384-math.modf(300*hp[1]/hpmax[1]),192,384,204,M_Red)
lib.FillColor(384,192,384+math.modf(300*hp[2]/hpmax[2]),204,M_Blue)
DrawBox(81,192,687,204,M_White)
for i=1,2 do
if s[i].action==0 then
lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==1 then
lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==2 then
lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1+2+8,s[i].effect) 
end
elseif s[i].action==3 then
lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1)
if s[i].effect>0 then 
lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1+2+8,s[i].effect) 
end
elseif s[i].action==4 then
lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==5 then
lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==6 then
lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1+2+8,s[i].effect)
end
end
end
lib.PicLoadCache(4,206*2,0,0,1)
DrawString(384-#fightname*16/2/2,8,fightname,M_White,16)
end
local function turn(id,d)
if s[id].d==d then
return
end
s[id].action=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
if s[id].d~=0 then
s[id].d=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
s[id].d=d
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(6)
ReFresh(2)
end
local function move(id,dx)
local flag=1
s[id].action=1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local step=12
if dx<s[id].x then
step=-12
end
for i=s[id].x,dx,step do
s[id].x=i
s[id].frame=s[id].frame+1
if s[id].frame>=2 then
s[id].frame=0
end
JY.ReFreshTime=lib.GetTime()
show()
if flag==1 then
PlayWavE(s[id].movewav)
flag=4
else
flag=flag-1
end
ReFresh(3)
lib.GetKey()
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh(2)
end
local function move2(dx1,dx2)
local count=1
local step1,step2=12,12
if dx1<s[1].x then
step1=-12
turn(1,2)
else
turn(1,3)
end
if dx2<s[2].x then
step2=-12
turn(2,2)
else
turn(2,3)
end
s[1].action=1
s[2].action=1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local mt=0
while true do
local flag=true
if s[1].x~=dx1 then
flag=false
s[1].x=s[1].x+step1
s[1].frame=s[1].frame+1
if s[1].frame>=2 then
s[1].frame=0
end
else
s[1].action=0
end
if s[2].x~=dx2 then
flag=false
s[2].x=s[2].x+step2
s[2].frame=s[2].frame+1
if s[2].frame>=2 then
s[2].frame=0
end
else
s[2].action=0
end
JY.ReFreshTime=lib.GetTime()
show()
if count==1 then
if s[1].action==1 then
PlayWavE(s[1].movewav)
end
if s[2].action==1 then
PlayWavE(s[2].movewav)
end
count=4
else
count=count-1
end
ReFresh(4)
lib.GetKey()
if flag then
break
end
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
local function atk_p(id,gd)--��ͨ���� ƽ�� gd ��������
local n=3
local flag=false
s[id].action=2
s[3-id].action=2
if math.random(gd)>50 then
flag=true
PlayWavE(6)
s[1].txt=str[2][math.random(10)]
s[2].txt=str[2][math.random(10)]
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
end
for i=0,3 do
s[id].frame=i
s[3-id].frame=i
if flag and i==0 then
PlayWavE(33)
for t=8,192,8 do
s[id].effect=t
s[3-id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[1].effect=0
s[2].effect=0
end
if i==3 then
if flag then
PlayWavE(31)
s[1].txt=str[5][math.random(15)]
s[2].txt=str[5][math.random(15)]
else
PlayWavE(30)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if flag then
if s[3-id].x>s[id].x then
s[3-id].x=s[3-id].x+24
s[id].x=s[id].x-24
else
s[3-id].x=s[3-id].x-24
s[id].x=s[id].x+24
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_ms(id,gd)--��ɱ gd ��������
local n=3
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
if ID[id]==2 then
s[id].txt=str[3][math.random(15)].."*���ն��"
end
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=24,240,6 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if s[3-id].x>s[id].x then
s[id].x=s[3-id].x-size
else
s[id].x=s[3-id].x+size
end
if math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,20+atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,300+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag then
s[id].x=s[3-id].x-size
s[3-id].x=s[3-id].x+size
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
end
else
if flag then
s[id].x=s[3-id].x+size
s[3-id].x=s[3-id].x-size
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_aq(id,gd)--����͵Ϯ gd��ʾ�񵲼���
local n=3
s[id].action=2
local flag1,flag2=0,false
if math.random(5)==1 then
flag1=1
end
if ID[id]==170 then--����
if flag1==0 then
if math.random(4)==1 then
flag1=1
end
end
gd=gd/2
end
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(6)
s[id].txt="�ٺٺ�*���ù���һ����"
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
if flag1==1 then
PlayWavE(33)
for t=8,192,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
end
s[id].effect=0
PlayWavE(37)
end
if i==3 then
if math.random(100)<gd then
flag2=true
s[3-id].action=3
PlayWavE(30+flag1)
dechp(3-id,atk[id]*(1+flag1),true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag2=false
s[3-id].action=4
PlayWavE(35+flag1)
dechp(3-id,(atk[id]+10)*(1+flag1))
atk[3-id]=atk[3-id]-1
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if flag2 then
s[3-id].txt="���С����"
else
s[3-id].txt="���ɣ�"
card_num[3-id]=card_num[3-id]-1
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_dz(id)--��ͨ���� ������
local n=3
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
PlayWavE(7)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_dl(id)--���� ������
s[id].txt="�ɶ񰡣���*��Ҫ�����㣡����"
atk_dz(id)
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
s[id].action=2
for t=1,3 do
for i=0,3 do
s[id].frame=i
if i==3 then
PlayWavE(7)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
end
end
local function atk_jj(id)--����
s[id].txt="��~������~"
PlayWavE(8)
s[id].action=5
for i=1,10 do
s[id].frame=i%2
if i==5 then
PlayWavE(8)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(8)
end
s[id].txt="�����һ��ж�*�Ͻ���һ�Űɣ�"
PlayWavE(41)
for t=8,255,8 do
s[id].effect=t
hp[id]=hp[id]+1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
s[id].action=0
s[id].frame=0
s[id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(6)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s0(id,gd)--��ͨ���� gd��ʾ�񵲼���
local n=3
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
if math.random(100)<gd then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,atk[id]/2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(35)
dechp(3-id,atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s1(id,gd)--С���� gd��ʾ�񵲼���
local n=3
s[id].action=2
local m=24
s[id].txt=str[2][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
end
if i==3 then
if math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
m=12
s[3-id].action=3
PlayWavE(31)
s[3-id].effect=192
dechp(3-id,1+atk[id]/2,true)
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,5+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
s[3-id].x=s[3-id].x+m
else
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s2(id,gd)--������ gd��ʾ�񵲼���
local n=3
local flag=true
s[id].txt=str[2][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,96,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
s[id].action=2
for t=1,3 do
for i=0,3 do
s[id].frame=i
if i==3 then
if flag and math.random(100)<gd+t*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,1,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,1+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if t==1 then
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
end
end
if flag then
s[3-id].txt=str[5][math.random(15)]
else
s[3-id].txt=str[4][math.random(15)]
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s3(id,gd)--�󱩻� gd��ʾ�񵲼���
local n=3
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=24,240,6 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,2+atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,15+atk[id]*2.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag or s[3-id].x>672-size*2 then
s[3-id].x=s[3-id].x+size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
end
else
if flag or s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s4(id,gd)--������ gd��ʾ�񵲼���
local n=3
local flag=true
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,128,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].action=2
for t=1,5 do
for i=0,3 do
s[id].frame=i
if i==3 then
if flag and math.random(100)<gd+t*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,1,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,2+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
if t%2==0 then
JY.ReFreshTime=lib.GetTime()
ReFresh(1)
end
end
end
if flag then
s[3-id].txt=str[5][math.random(15)]
else
s[3-id].txt=str[4][math.random(15)]
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s5(id,gd)--����ǹ gd��ʾ�񵲼���
local n=3
local m=size/2
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==3 then
if math.random(100)<gd then
flag=true
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(35)
dechp(3-id,2+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if s[id].x<s[3-id].x then
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
turn(id,2)
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
turn(id,3)
end
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,240,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
end
if i==3 then
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
if flag and math.random(100)<gd+10 then
s[3-id].txt=str[5][math.random(15)]
m=size/4
s[3-id].action=3
PlayWavE(31)
s[3-id].effect=192
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
dechp(3-id,2+atk[id]/2,true)
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,15+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if s[id].x<size then
m=size
end
s[3-id].x=s[3-id].x+m
else
if s[id].x>672-size then
m=size
end
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s6(id,gd)--������ gd��ʾ�񵲼���
local n=3
local m=36
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,240,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if math.random(100)<gd then
flag=true
m=24
s[3-id].action=3
PlayWavE(31)
dechp(3-id,atk[id]-2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(36)
dechp(3-id,5+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if s[3-id].x>s[id].x then
if s[id].x<672-size*2 then
s[3-id].x=s[3-id].x+m
end
else
if s[id].x>size*2 then
s[3-id].x=s[3-id].x-m
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
if s[3-id].x>s[id].x then
s[id].x=s[3-id].x-size
else
s[id].x=s[3-id].x+size
end
PlayWavE(s[id].movewav)
if flag and math.random(100)<gd-10 then
s[3-id].txt=str[5][math.random(15)]
s[3-id].action=3
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
PlayWavE(31)
s[3-id].effect=192
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
dechp(3-id,atk[id],true)
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,20+atk[id]*2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
s[3-id].effect=0
if s[id].x<s[3-id].x then
if s[3-id].x>672-size*2 then
s[3-id].x=s[3-id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[3-id].x=s[3-id].x+size/4
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
else
if s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[3-id].x=s[3-id].x-size/4
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s7(id,gd)--������ gd��ʾ�񵲼���
local n=3
local m=24
local lianji=6
local flag=true
 
if s[id].x<s[3-id].x then
if s[id].x<size*2 then
lianji=7
end
else
if s[id].x>672-size*2 then
lianji=7
end
end
 
s[id].action=2
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,192,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
for count=1,lianji do--7 do
for i=0,3 do
s[id].frame=i
if i==3 then
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
if flag and math.random(100)<gd+count*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,3+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
end
if s[id].x<s[3-id].x then
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].d=2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].d=3
end
end
if flag then
s[3-id].txt=str[5][math.random(15)]
else
s[3-id].txt=str[4][math.random(15)]
end
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end 
local function atk_s8(id,gd)--�ؼ� gd��ʾ�񵲼���
local n=3
local flag=true
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,128,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].action=2
for t=1,7 do
for i=0,3 do
s[id].frame=i
if i==3 then
if math.random(100)<gd then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,4)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
end
end
 
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=128,248,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if flag and math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,40+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag or s[3-id].x>672-size*2 then
s[3-id].x=s[3-id].x+size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
end
else
if flag or s[3-id].x<size*2 then
s[3-id].x=s[3-id].x+-size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end 
local function win(id)
local eid=3-id
s[eid].txt=str[6][math.random(15)]
PlayWavE(38)
s[eid].action=5
for i=1,4 do
if s[eid].action==9 then
s[eid].action=5
else
s[eid].action=9
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(3)
end
for i=16,128,16 do
s[eid].effect=i
if s[eid].action==9 then
s[eid].action=5
else
s[eid].action=9
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
end
PlayWavE(22)
s[eid].losser=true
s[eid].action=5
for i=128,256,16 do
s[eid].effect=i
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
s[eid].action=9
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(20)
s[id].action=0
s[id].d=0
s[id].txt=str[7][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
s[id].action=6
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(8)
ReFresh(12)
PlayWavE(5)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
if hp[id]==hpmax[id] then
DrawString(288,210,JY.Person[ID[id]]["����"].." ��ʤ",M_White,48)
else
DrawString(288,210,JY.Person[ID[id]]["����"].." ʤ",M_White,48)
end
for t=1,10 do
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
end
end
local function card_ini(idx)
card[idx]={}
for i=1,card_num[idx] do
card[idx][i]=math.random(9)
end
end
local function card_sort(idx)
for i=1,card_num[idx]-1 do
for j=i+1,card_num[idx] do
if card[idx][i]>card[idx][j] then
card[idx][i],card[idx][j]=card[idx][j],card[idx][i]
end
end
end
end
local function card_value(id,n1,n2,n3)
local pid=ID[id]
local wl=JY.Person[pid]["����"]
local offset=0--math.max(math.modf(wl/2)-41,0)
offset=math.max(wl/2-41,0)
local v=0
local k=0--0��ͨ���� 1С���� 2������ 3�󱩻� 4������
--����:���ն,�����ɷն==>��ƽ,����,����Ҳ�� 
--�ŷ�:��Ϯ�������,������==>�Ű�Ҳ�� 
--����:����,��ӥ==>��ͳ,�Թ�Ҳ�� 
--��:���֮���� 
--����:��֮����
--specil 444
--mp[id]=100--����mp
if wl>=100 and mp[id]>=99 and n1==4 and n2==4 and n3==4 then
return 65,9
end
--����1 ���������ӱ������� 1 111
if JY.Person[pid]["�ؼ�1"]>0 and mp[id]>=60 and n1==1 and n2==1 and n3==1 then
return 60+offset,8
end
--�������� ������������ 1 378
if (JY.Person[pid]["����"]==4 or JY.Person[pid]["����"]==5 or JY.Person[pid]["����"]==6 or JY.Person[pid]["����"]==7) and mp[id]>=55 and n1==3 and n2==7 and n3==8 then
return 55+offset,7
end
--�������� �Ȼ��ˣ�Ȼ�󱩻����� 1 159
if (JY.Person[pid]["����"]==4 or JY.Person[pid]["����"]==5 or JY.Person[pid]["����"]==6 or JY.Person[pid]["����"]==7) and mp[id]>=55 and n1==1 and n2==5 and n3==9 then
return 55+offset,6
end
--����ǹ ��ͨ���ˣ��ӱ��� 3 557/567/577
if JY.Person[pid]["����"]>0 and mp[id]>=50 and n1==5 and n3==7 then
return 50+offset,5
end
--����ǿ�� 258
if mp[id]>=40 and n1==2 and n2==5 and (n3==8 or n3==9) then
if pid==54 then--����
return 45+offset,7--������
elseif pid==190 then--��
return 45+offset,5--����
elseif pid==2 then--����
return 45+offset,99--һ��
elseif pid==3 then--�ŷ�
return 45+offset,6--������
elseif pid==5 then--����
return 45+offset,8--����1
end
end
--������ 3 334/345/356
if (JY.Person[pid]["����"]==2 or JY.Person[pid]["����"]==3 or JY.Person[pid]["����"]==6 or JY.Person[pid]["����"]==7) and mp[id]>=45 and n1==3 and n3<7 and n2+1==n3 then
return 40+offset,4
end
--�󱩻� �������� 4 266/277/288/299
if (JY.Person[pid]["����"]==2 or JY.Person[pid]["����"]==3 or JY.Person[pid]["����"]==6 or JY.Person[pid]["����"]==7) and mp[id]>=45 and n1==2 and n2>5 and n2==n3 then
return 40+offset,3
end
--���� ������ 7-1 123/234/345/456/567/678/789
if (JY.Person[pid]["����"]==1 or JY.Person[pid]["����"]==3 or JY.Person[pid]["����"]==5 or JY.Person[pid]["����"]==7) and mp[id]>=40 and n1+1==n2 and n2+1==n3 then
return 30+offset,2
end
--���� С���� 9-1-1 111/222/333/444/555/666/777/888/999
if (JY.Person[pid]["����"]==1 or JY.Person[pid]["����"]==3 or JY.Person[pid]["����"]==5 or JY.Person[pid]["����"]==7) and mp[id]>=40 and n1==n2 and n2==n3 then
return 30+offset,1
end
return n1+n2+n3,0
end
local function card_remove(id,t1,t2,t3)
for i=1,card_num[id] do
if card[id][i]==t1 then
table.remove(card[id],i)
break
end
end
for i=1,card_num[id]-1 do
if card[id][i]==t2 then
table.remove(card[id],i)
break
end
end
for i=1,card_num[id]-2 do
if card[id][i]==t3 then
table.remove(card[id],i)
break
end
end
table.remove(card[id],1)
for i=card_num[id]-3,card_num[id] do
card[id][i]=math.random(9)
end
end
local function card_ai(id)
local t1,t2,t3
local vmax=0
local kind
card_sort(id)
for i=1,card_num[id]-2 do
for j=i+1,card_num[id]-1 do
for k=j+1,card_num[id] do
local v1,v2=card_value(id,card[id][i],card[id][j],card[id][k])
if v1>vmax then
vmax=v1
kind=v2
t1,t2,t3=card[id][i],card[id][j],card[id][k]
end
end
end
end
card_remove(id,t1,t2,t3)
return vmax,kind--,t1,t2,t3
end
card_ini(1)
card_ini(2)
local action_v={}
local action_k={}
local function automove()--����ӽ����Զ�����Ļ�����ƶ�
local cx=348
local cur=1
if math.abs(s[1].x-cx)<math.abs(s[2].x-cx) then
cur=2
end
if math.abs(s[cur].x-s[3-cur].x)>size then
if s[cur].x>s[3-cur].x then
move(cur,s[3-cur].x+size)
else
move(cur,s[3-cur].x-size)
end
end
end
local function arrive(id)
s[id].action=0
PlayWavE(5)
for i=256,0,-4 do
s[id].effect=i
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
show()
Light()
PlayWavE(4)
arrive(1)
local talkid=math.random(15)
s[1].txt=string.format(str[1][talkid*2-1],p1["���"])
s[1].d=3
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
arrive(2)
s[2].txt=string.format(str[1][talkid*2],p2["���"])
s[2].d=2
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
local msflag=false
for i=1,2 do
local pid=ID[i]
local eid=ID[3-i]
if JY.Person[pid]["һ��"]>0 and JY.Person[pid]["����"]-JY.Person[eid]["����"]>=5 and math.random(100)<=25 then
atk_ms(i,JY.Person[eid]["����"]-65)
mp[i]=0
msflag=true
if hp[1]==0 then
win(2)
return 2
elseif hp[2]==0 then
win(1)
return 1
end
break
end
end
if not msflag then
for i=1,2 do
local pid=ID[i]
local eid=ID[3-i]
if JY.Person[pid]["����"]>0 and math.random(10)<=5 then
atk_aq(i,JY.Person[eid]["����"]-30)
break
end
end
move2(288,384)
else
automove()
end
while true do
local cur=1
for i=1,2 do
action_v[i],action_k[i]=card_ai(i)
end
automove()
if math.abs(action_v[1]-action_v[2])<=1 then
atk_p(1,action_v[1]+action_v[2])
else
if action_v[1]>action_v[2] then
cur=1
else
cur=2
end
automove()
local gd=s[3-cur].luck+20*action_v[3-cur]/action_v[cur]
if action_k[cur]==0 then
atk_s0(cur,gd)
elseif action_k[cur]==1 then
atk_s1(cur,gd)
elseif action_k[cur]==2 then
atk_s2(cur,gd)
elseif action_k[cur]==3 then
atk_s3(cur,gd)
elseif action_k[cur]==4 then
atk_s4(cur,gd)
elseif action_k[cur]==5 then
atk_s5(cur,gd)
elseif action_k[cur]==6 then
atk_s6(cur,gd)
elseif action_k[cur]==7 then
atk_s7(cur,gd)
elseif action_k[cur]==8 then
atk_s8(cur,gd)
elseif action_k[cur]==9 then
atk_s8(cur,5)
elseif action_k[cur]==99 then
atk_ms(cur,JY.Person[ID[3-cur]]["����"]-60)
else
atk_s0(cur,gd)
end
if action_k[cur]~=0 then
admp(cur,-math.modf(action_v[cur]/10)*8)--����������mp
end
if action_k[3-cur]~=0 then
--admp(3-cur,-math.modf(action_v[3-cur]/10)*5)--�����߲�����mp
end
end
if hp[1]==0 then
win(2)
return 2
elseif hp[2]==0 then
win(1)
return 1
end
if s[1].x>s[2].x then
turn(1,2)
turn(2,3)
else
turn(1,3)
turn(2,2)
end
--����
if hp[3-cur]<hpmax[3-cur]/2 and s[3-cur].jj>0 and math.random(100)<=20 then
s[3-cur].jj=0
atk_jj(3-cur)
end
--����
if hp[3-cur]<hpmax[3-cur]/3 and s[3-cur].dl>0 and math.random(100)<=30 then
s[3-cur].dl=0
atk_dl(3-cur)
card_num[3-cur]=card_num[3-cur]+1
card[3-cur][card_num[3-cur]]=math.random(9)
admp(3-cur,100)
end
JY.ReFreshTime=lib.GetTime()
show()
for i=1,2 do
admp(i,s[i].mpadd)
--action_v[i],action_k[i]=card_ai(i)
end
ReFresh(4)
end
end

--ԭwar.lua
function war(id1,id2,sid)
local n=2
local ID={id1,id2}
local p1,p2=JY.Person[id1],JY.Person[id2]
local bzpic1,bzpic2
local s={}
bzpic1=GetBZPic(id1,false,false)
bzpic2=GetBZPic(id2,true,false)
for i=0,100 do
s[i]={
d=3,--0123 ��������
x=142+32*math.modf(i/9),
y=300+18*(i%9),
pic=bzpic1,
action=0,--0��ֹ 1�ƶ� 2���� 3���� 4������ 5���� 9������
frame=0,
effect=0,
movewav=JY.Bingzhong[p1["����"]]["��Ч"],
txt="",
leader=false,
}
end
local sy=270
local pic1=0
local pic2=10
-- 00 ƽԭ 01 ɭ�� 02 ɽ�� 03 ���� 04 ���� 05 ��ǽ 06 �ǳ� 07 ��ԭ
-- 08 ��ׯ 09 ���� 0A ���� 0B �ĵ� 0C դ�� 0D ¹�� 0E ��Ӫ 0F ����
-- 10 ����� 11 ���� 12 ���� 13 ����
if sid==0 or sid==7 then
pic1=4
pic2=12
elseif sid==2 or sid==11 then
pic1=0
pic2=13
elseif sid==1 then
pic1=3
pic2=12
elseif sid==4 then
pic1=1
pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
pic1=2
pic2=10
end
local test_n=88
local array=WarFormation(1,test_n)
for i=1,test_n do
s[i].x=200+array.x[i]
s[i].y=350+array.y[i]
s[i].pic=bzpic1
s[i].leader=false
end
s[array.leader].leader=true
s[array.leader].pic=p1["ս������"]
s[array.leader].y=s[array.leader].y-16
local function show()
local piccacheid=12
local size=60
local size2=80
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(1,pic2*2,0,310,1)
lib.PicLoadCache(1,pic1*2,-68,190,1)
for i=1,test_n do
if s[i].leader then
piccacheid=12
size=60
size2=80
else
piccacheid=1
size=48
size2=64
end
if s[i].action==0 then
lib.PicLoadCache(piccacheid,(s[i].pic+16+s[i].d)*2,s[i].x,s[i].y,1)
elseif s[i].action==1 then
lib.PicLoadCache(piccacheid,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,s[i].y,1)
elseif s[i].action==2 then
lib.PicLoadCache(piccacheid,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,s[i].y+(size-size2)/2,1)
elseif s[i].action==3 then
lib.PicLoadCache(piccacheid,(s[i].pic+22+s[i].d)*2,s[i].x,s[i].y,1)
elseif s[i].action==4 then
lib.PicLoadCache(piccacheid,(s[i].pic+26+s[i].d%2)*2,s[i].x,s[i].y,1)
elseif s[i].action==5 then
lib.PicLoadCache(piccacheid,(s[i].pic+20+s[i].frame)*2,s[i].x,s[i].y,1)
elseif s[i].action==6 then
lib.PicLoadCache(piccacheid,(s[i].pic+28)*2,s[i].x,s[i].y,1)
end
end
lib.PicLoadCache(2,230*2,0,0,1)
end
local function move(dx)
local flag=1
for id=0,100 do
s[id].action=1
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local step=18
if dx<s[0].x then
step=-step
end
for i=s[0].x,dx,step do
for id=0,100 do
s[id].x=s[id].x+step
s[id].frame=s[id].frame+1
if s[id].frame>=2 then
s[id].frame=0
end
end
JY.ReFreshTime=lib.GetTime()
show()
if flag==1 then
PlayWavE(s[0].movewav)
flag=4
else
flag=flag-1
end
ReFresh(2)
lib.GetKey()
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
move(600)
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
WaitKey()
end

function WarFormation(kind,n)
local array={}
array.x={}
array.y={}
array.leader=1
if kind==1 then
--Բ��
--1 8 16 24 32
local T={1,8,16,24,32,40,48}
local T2={1,9,25,49,81,121,169}
local lv=1
local len=0
if n>49 then
lv=5
len=40
elseif n>25 then
lv=4
len=40
elseif n>9 then
lv=3
len=48
elseif n>1 then
lv=2
len=54
end
T[2]=math.modf(T[2]*n/T2[lv])
T[3]=math.modf(T[3]*n/T2[lv])
T[4]=math.modf(T[4]*n/T2[lv])
T[5]=math.modf(T[5]*n/T2[lv])
if lv==2 then
 T[2]=n-T[1]
elseif lv==3 then
T[3]=n-T[2]-T[1]
elseif lv==4 then
T[4]=n-T[3]-T[2]-T[1]
elseif lv==5 then
T[5]=n-T[4]-T[3]-T[2]-T[1]
end
local num=1
array.x[1]=0
array.y[1]=0
array.leader=1
num=2
for i=2,lv do
for t=1,T[i] do
array.x[num]=math.modf(len*(i-1)*math.cos(2*math.pi*t/T[i]))
array.y[num]=math.modf(len*0.6*(i-1)*math.sin(2*math.pi*t/T[i]))
num=num+1
end
end
elseif kind==2 then
--����
local lv=1
local len=0
array.leader=1
if n>81 then
lv=10
len=32
array.leader=5
elseif n>64 then
lv=9
len=36
array.leader=5
elseif n>49 then
lv=8
len=40
array.leader=4
elseif n>36 then
lv=7
len=44
array.leader=4
elseif n>25 then
lv=6
len=48
array.leader=3
elseif n>16 then
lv=5
len=52
array.leader=3
elseif n>9 then
lv=4
len=56
array.leader=2
elseif n>4 then
lv=3
len=60
array.leader=2
elseif n>1 then
lv=2
len=64
end
fornum=1,n do
local x=math.modf((num-1)/lv)
local y=(num-1)%lv
array.x[num]=math.modf(len*((lv-1)/2-x))
array.y[num]=math.modf(len*0.6*(y-(lv-1)/2))
end
end
--��ʸ
--����
--׶��
--����
--����
local theat=math.pi/24
for i=1,n do
array.x[i]=array.x[i]*(1+array.y[i]/100*math.tan(theat))
end
for i=1,n-1 do
for j=i+1,n do
if array.y[i]>array.y[j] or (array.y[i]==array.y[j] and array.x[i]>array.x[j]) then
array.x[i],array.x[j]=array.x[j],array.x[i]
array.y[i],array.y[j]=array.y[j],array.y[i]
if i==array.leader then
array.leader=j
elseif j==array.leader then
array.leader=i
end
end
end
end
return array
end

--ԭmouse.lua
MOUSE={
x=0,
y=0,
hx=0,
hy=0,
rx=0,
ry=0,
status='IDLE',
Holdtime=0;--���ڼ��㳤��
enableclick=true;
EXIT=function()
if MOUSE.status=='EXIT' then
MOUSE.status='IDLE';
return true;
end
return false;
end,
ESC=function()
if MOUSE.status=='ESC' then
MOUSE.status='IDLE';
return true;
end
return false;
end,
IN=function(x1,y1,x2,y2)
if MOUSE.status=='IDLE' or MOUSE.status=='HOLD' or MOUSE.status=='CLICK' or MOUSE.status=='ESC'then
if between(MOUSE.x,x1,x2) and
between(MOUSE.y,y1,y2) then
return true;
end
end
return false;
end,
HOLD=function(x1,y1,x2,y2,t)
t=t or 0;
if MOUSE.status=='HOLD' then
if between(MOUSE.x,x1,x2) and
between(MOUSE.y,y1,y2) and
between(MOUSE.hx,x1,x2) and
between(MOUSE.hy,y1,y2) then
return true;
end
end
return false;
end,
CLICK=function(x1,y1,x2,y2)
if MOUSE.status=='CLICK' then
if x1==nil then
MOUSE.status='IDLE';
return true;
end
if between(MOUSE.rx,x1,x2) and
between(MOUSE.ry,y1,y2) and
between(MOUSE.hx,x1,x2) and
between(MOUSE.hy,y1,y2) then
MOUSE.status='IDLE';
return true;
end
end
return false;
end,
}
function getkey()
if CONFIG.Windows then
return getkey_pc();
else
return getkey_sp();
end
end

function getkey_pc()
local eventtype,keypress,x,y=lib.GetKey(1);
if(eventtype ~= -1) then
lib.Debug(string.format("getkey_pc eventtype =%d x=%d y=%d keypress=%d",eventtype,x,y,keypress))
end
if eventtype==0 then
MOUSE.status='EXIT';
elseif eventtype==3 then
if keypress==1 then
MOUSE.status='HOLD';
MOUSE.x,MOUSE.y=x,y;
MOUSE.hx,MOUSE.hy=x,y;
elseif keypress==3 then
MOUSE.status='ESC';
end
else
local mask;
mask,x,y=lib.GetMouse();
MOUSE.x,MOUSE.y=x,y;
if mask==0 then
if MOUSE.status=='HOLD' then
if MOUSE.enableclick then
MOUSE.status='CLICK';
MOUSE.rx,MOUSE.ry=x,y;
else
MOUSE.enableclick=true;
MOUSE.status='IDLE';
end
end
end
end
if(eventtype ~= -1) then
lib.Debug(string.format("getkey_pc2 eventtype =%d x=%d y=%d keypress=%d",eventtype,x,y,keypress))
end
return eventtype,keypress,x,y;
end

function getkey_sp()
local eventtype,keypress,x,y=lib.GetKey(1);
if(eventtype ~= -1) then
lib.Debug(string.format("getkey_sp eventtype =%d x=%d y=%d",eventtype,x,y))
end
if eventtype==0 then
MOUSE.status='EXIT';
elseif eventtype==2 then
MOUSE.x,MOUSE.y=x,y;
elseif eventtype==3 then
if keypress==1 then
MOUSE.status='HOLD';
MOUSE.x,MOUSE.y=x,y;
MOUSE.hx,MOUSE.hy=x,y;
elseif keypress==3 then
MOUSE.status='ESC';
end
elseif eventtype==4 then
if keypress==1 then
if MOUSE.status=='HOLD' then
if MOUSE.enableclick then
MOUSE.status='CLICK';
MOUSE.x,MOUSE.y=x,y;
MOUSE.rx,MOUSE.ry=x,y;
else
MOUSE.enableclick=true;
MOUSE.status='IDLE';
MOUSE.x,MOUSE.y=x,y;
end
end
else
MOUSE.status='IDLE';
MOUSE.x,MOUSE.y=x,y;
end
end
if(eventtype ~= -1) then
lib.Debug(string.format("getkey_sp2 eventtype =%d x=%d y=%d keypress=%d",eventtype,x,y,keypress))
end
return eventtype,keypress,x,y;
end
