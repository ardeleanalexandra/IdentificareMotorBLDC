%% Achizitia datelor

t=double(apofaian_roxana.X.Data)';%timp
y=double(apofaian_roxana.Y(1,1).Data)';%pozitie 
w=double(apofaian_roxana.Y(1,2).Data)';%viteza unghiulara rad/s
u=double(apofaian_roxana.Y(1,3).Data)';%intrare fu

plot(t,[u*200 w y]),shg
title('Date initiale'),xlabel('Timp(s)'),ylabel('Fact de umplere, rad/s, impulsuri');

figure
subplot(311);plot(t,u);
title('Intrarea u'),xlabel('Timp(s)'),ylabel('Factorul de umplere')
subplot(312);plot(t,w);
title('Viteza w'),xlabel('Timp(s)'),ylabel('rad/s')
subplot(313);plot(t,y);
title('Pozita y'),xlabel('Timp(s)'),ylabel('impulsuri')


% pt identificare
i1=2073;
i2=4097;
%pt validare
i3=5211;
i4=7444;

%Timpul de esantionare
Te=t(2)-t(1);

i_id=[2073:4097]';
i_vd=[5211:7444]';

figure
plot(t(i_id),[u(i_id)*200 w(i_id) y(i_id)]),shg,grid

figure
plot(t(i_vd),[u(i_vd)*200 w(i_vd) y(i_vd)]),shg,grid

dw_id_w=iddata(w(i_id),u(i_id),Te);
dw_vd_w=iddata(w(i_vd),u(i_vd),Te);

dy_id_y=iddata(y(i_id),u(i_id),Te);
dy_vd_y=iddata(y(i_vd),u(i_vd),Te);

%% decimare date
N=18;
t_dec=t(1:N:end);
Te_dec=t_dec(2)-t_dec(1);
u_dec=u(1:N:end);
w_dec=w(1:N:end);
y_dec=y(1:N:end);

plot(t,w)
%graficul cu datele decimate
figure
plot(t_dec, w_dec) 

t1=123;
t2=231;
t3=300;
t4=405;

i_id_dec=[123:231]';
i_vd_dec=[300:405]';

dw_id_w_dec=iddata(w_dec(i_id_dec),u_dec(i_id_dec),Te_dec);
dw_vd_w_dec=iddata(w_dec(i_vd_dec),u_dec(i_vd_dec),Te_dec);

dy_id_y_dec=iddata(y_dec(i_id_dec),u_dec(i_id_dec),Te_dec);
dy_vd_y_dec=iddata(y_dec(i_vd_dec),u_dec(i_vd_dec),Te_dec);

%% IDENTIFICARE CU ARX/IV PENTRU VITEZA
%ARX viteza-71
Mw_arx=arx(dw_id_w,[1, 1, 0])
Hz1_arx=tf(Mw_arx.B,Mw_arx.A,Te)
Hs1_arx=d2c(Hz1_arx,'zoh')
figure
resid(dw_vd_w,Mw_arx,5);
figure
compare(dw_vd_w,Mw_arx);


%Iv viteza-70
Mw_iv=iv4(dw_id_w,[1, 1 ,0])
Hz2_iv=tf(Mw_iv.B,Mw_iv.A,Te)
Hs2_iv=d2c(Hz2_iv,'zoh')

resid(dw_id_w,Mw_iv,5),shg
figure 
compare(dw_vd_w,Mw_iv),shg


%% ARX/OE pt pozitie
%OE- poz
My_oe=oe(dy_id_y,[1, 1, 0])
Hz4_oe=tf(My_oe.B,My_oe.F,Te)
Hs4=d2c(Hz4_oe,'zoh')
figure
resid(dy_vd_y,My_oe,5),shg
figure
compare(dy_vd_y,My_oe),shg



%ARX-poz
My_arx=arx(dy_id_y_dec,[1, 1 ,1])
Hz3_arx=tf(My_arx.B,My_arx.A,Te_dec)
Hs3=d2c(Hz3_arx,'zoh')
resid(dy_vd_y_dec,My_arx,10)
figure
compare(dy_vd_y_dec,My_arx)






