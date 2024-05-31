% images for the hardware verification post
% 
% mpost -tex=latex circuits.mp
verbatimtex \nofiles\documentclass{article} etex;
prologues := 3;
outputtemplate := "%j-%c.png";
outputformat := "png";

numeric u;

u := 1pc;

beginfig(1)
  numeric i;
  path p[];
  p[0] = (0,-0.5u)--(0,0.5u)--(u,0)--cycle;    % buffer
  p[1] = fullcircle scaled 6 shifted (u+6,0);  % negation
  p[2] = (u+12,0)--(6u,0)--(6u,-4u)--(u,-4u);  % right wire
  p[3] = (u,-4.5u)--(u,-3.5u)--(0,-4u)--cycle; % buffer
  p[4] = fullcircle scaled 6 shifted (-6,-4u); % negation
  p[5] = (-12,-4u)--(-6u,-4u)--(-6u,0)--(0,0); % left wire

  draw p0;
  draw p1;
  draw p2;
  draw p3;
  draw p4;
  draw p5;

  label.lft(btex \huge $A$ etex, (-6u,-2u));
  label.rt(btex \huge $B$ etex, (6u,-2u));

  drawdot (-6.1u,-4u); % for visibility purposes
endfig;

% u := 2pc;
beginfig(2)
  numeric i;
  path p[];
  p[0] = (0,-0.5u)--(0,0.5u)--(u,0)--cycle;    % buffer
  p[1] = fullcircle scaled 6 shifted (u+6,0);  % negation
  p[2] = (u+12,0)--(6u,0)--(6u,-4u)--(u,-4u);  % right wire
  p[3] = (u,-4.5u)--(u,-3.5u)--(0,-4u)--cycle; % buffer
  p[4] = fullcircle scaled 6 shifted (-6,-4u); % negation
  p[5] = (-12,-4u)--(-6u,-4u)--(-6u,0)--(0,0); % left wire

  draw p0;
  draw p1;
  draw p2;
  draw p3;
  draw p4;
  draw p5;

  label.lft(btex \huge $Q$ etex, (-6u,-2u));
  label.rt(btex \huge $\bar{Q}$ etex, (6u,-2u));

  drawdot (-6.1u,-4u); % for visibility purposes
endfig;

end;