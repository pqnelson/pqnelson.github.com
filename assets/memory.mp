outputformat := "png"; % "svg"; % "png";
outputtemplate := "%j-%c.%o";
prologues := 3;
hppp := 2.0;
vppp := 2.0;
beginfig(0);
  numeric u; u := 1pc;
  z[0] = (0,0);
  z[1] = (0,u);
  z[2] = (6u, u);
  z[3] = (6u, 0);

  label.top(btex h etex, z0 + (0.5u,0u));
  label.top(btex e etex, z0 + (1.5u,0u));
  label.top(btex l etex, z0 + (2.5u,0u));
  label.top(btex l etex, z0 + (3.5u,0u));
  label.top(btex o etex, z0 + (4.5u,0u));

  numeric i;

  numeric dx;
  numeric dy;
  dx := u/4;
  dy := u/4;
  for i=1 upto 4:
    draw (z3 + (0, (i - 0.5)*dy)) -- (z3 + (-(i - 0.5)*dx, 0)) withcolor 0.5[black,white];
  endfor;
  for i=1 upto 4:
    draw (z2 + (-(i - 0.5)*dx, 0))--(z3 + (-u, (i - 0.5)*dy)) withcolor 0.5[black,white];
  endfor;

  for i=0 upto 6:
    draw (z0 + (i*u,0))--(z0 + (i*u,u));
  endfor;
  draw z0--z1--z2--z3--cycle;
endfig;

beginfig(1);
  pair Obj[];
  pair Cons[];
  numeric w;
  w := 1.25;
  dx := w*u;
  Obj[0] = (0,0);
  Obj[1] = (0,u);
  Obj[2] = (4dx,u);
  Obj[3] = (4dx,0);

  numeric consY;
  consY := -6u;
  Cons[0] = (0,consY);
  Cons[1] = (12dx, consY);
  Cons[2] = (12dx, u+consY);
  Cons[3] = (0, u+consY);

  label.bot(btex $\lbrace$ etex rotated 90 xscaled 4.5w yscaled 1.5,
      1/2[Obj[0], Obj[3]]);

  label.top(btex $\lbrace$ etex rotated -90 xscaled 4.5w yscaled 1.5,
      1/2[Obj[1], Obj[2]] + (0,consY));

  label.bot(btex $\lbrace$ etex rotated 90 xscaled 4.5w yscaled 1.5,
      1/2[Obj[0], Obj[3]] + (0,consY));

  label.bot(btex $\lbrace$ etex rotated 90 xscaled 4.5w yscaled 1.5,
      1/2[Obj[0], Obj[3]] + (4dx,consY));

  label.bot(btex $\lbrace$ etex rotated 90 xscaled 4.5w yscaled 1.5,
      1/2[Obj[0], Obj[3]] + (8dx,consY));

  label.bot(btex ObjectType etex, 1/2[Obj[0], Obj[3]] + (0,-1.5u));
  label.bot(btex type etex, 1/2[Obj[0], Obj[3]] + (0,-2.5u));
  label.bot(btex Object etex, 1/2[Obj[0], Obj[3]] + (0,consY-u));
  label.bot(btex header etex, 1/2[Obj[0], Obj[3]] + (0,consY-2u));
  label.bot(btex car etex, 1/2[Obj[0], Obj[3]] + (4dx,consY-u));
  label.bot(btex cdr etex, 1/2[Obj[0], Obj[3]] + (8dx,consY-u));



  draw (Obj[0] + (0,-1.5))--(Cons[3] + (0,1)) dashed evenly;
  draw (Obj[3] + (0,-1.5))--(Obj[3] + (0,1+u+consY)) dashed evenly;
  % draw Obj[0]--Cons[3] dashed withdots;
  % draw Obj[3]--(Obj[3] + (0,u+consY)) dashed withdots;


  label.ulft(btex \ struct Object etex, (-dx, 0));
  label.ulft(btex struct Cons etex, (-dx, consY));

  numeric i;
  for i=1 upto 3:
    draw (Obj[0] + (i*dx,0))--(Obj[1] + (i*dx, 0)) withcolor 0.5[black,white];
  endfor;
  color c;
  for i=1 upto 12:
    if 0 = i mod 4:
      c := black;
    else:
      c := 0.5[black, white];
    fi;
    draw (Cons[0] + (i*dx,0))--(Cons[3] + (i*dx, 0)) withcolor c;
  endfor;
  draw Cons[0]--Cons[1]--Cons[2]--Cons[3]--cycle;
  draw Obj[0]--Obj[1]--Obj[2]--Obj[3]--cycle;

endfig;
end;