% outputformat := "svg";
outputtemplate:="%j-%c.%o";
prologues := 3;
% 86.8kb ~ C*(expt (2 * n) k)
% 32.8kb ~ C*n
outputformat := "png";
% If we're making PNG files, we should uncomment one of the following:
hppp:=vppp:=0.24; % png format(300dpi)
%hppp:=vppp:=0.12; % png format(600dpi)
% hppp:=vppp:=0.06; % png format(12000dpi)
% based off of: https://ctan.math.utah.edu/ctan/tex-archive/graphics/mcf2graph/mcf2graph.mp

numeric u; u := 1pc;

% 4-node as equivalent to a Red-Black subtree
beginfig(0)
  path node[];
  numeric i;
  z[0] = (0,0);
  for i=1 upto 2:
    z[i] = z[i-1] + (u,0);
  endfor;
  z3 = z2 + (2u, 0);
  z4 = z3 + (2u,-u);
  z5 = z4 + (1.5u,1.5u);
  z6 = z5 + (1.5u,-1.5u);
  for i=0 upto 2:
    node[i] = unitsquare scaled u shifted (z[i] + (-0.5u,-0.5u));
  endfor;
  for i=4 upto 6:
    node[i] = unitsquare scaled u shifted (z[i] + (-0.5u,-0.5u));
  endfor;
  for i=0 upto 2:
    draw node[i];
  endfor;
  draw (z[4] + (0, 0.5u))--(z5 + (-0.5u, -0.5u));
  draw (z[6] + (0, 0.5u))--(z5 + (0.5u, -0.5u));
  draw node4 withcolor red;
  draw node6 withcolor red;
  draw node5;
  label(btex $\approx$ etex, z3);
  label(btex $a$ etex, z0);
  label(btex $b$ etex, z1);
  label(btex $c$ etex, z2);
  label(btex $a$ etex, z4);
  label(btex $b$ etex, z5);
  label(btex $c$ etex, z6);
endfig;

% left-3-node as equivalent to a Red-Black subtree
beginfig(1)
  path node[];
  pair subtrees[];
  path tree[];
  numeric i;
  z[0] = (0,0);
  for i=1 upto 2:
    z[i] = z[i-1] + (u,0);
  endfor;
  z3 = z2 + (2u, 0);
  z4 = z3 + (2u,-u);
  z5 = z4 + (1.5u,1.5u);
  z6 = z5 + (1.5u,-1.5u);
  for i=0 upto 2:
    node[i] = unitsquare scaled u shifted (z[i] + (-0.5u,-0.5u));
  endfor;
  for i=4 upto 5:
    node[i] = unitsquare scaled u shifted (z[i] + (-0.5u,-0.5u));
  endfor;
  for i=0 upto 2:
    draw node[i];
  endfor;
  subtrees[0] = z[0] + (-0.75u,-0.5u) + (-u,-u);
  subtrees[1] = z0 + (0.4u,-0.5u) + (0,-u);
  subtrees[2] = subtrees[1] + (2u,0);
  subtrees[3] = z[4] + (-0.75u,-0.5u) + (-0.5u,-u);
  subtrees[4] = z[4] + (0.75u,-0.5u) + (0.5u,-u);
  subtrees[5] = z[5] + (0.75u,-0.5u) + (0.5u,-u);
  for i=0 upto 5:
    tree[i] = subtrees[i] -- (subtrees[i] + (0.75u,-1.5u)) -- (subtrees[i] + (-0.75u,-1.5u)) -- cycle;
    draw tree[i];
  endfor;
  label(btex $t_{1}$ etex, subtrees0 + (1,-1u - 1));
  label(btex $t_{2}$ etex, subtrees1 + (1,-1u - 1));
  label(btex $t_{3}$ etex, subtrees2 + (1,-1u - 1));
  label(btex $t_{1}$ etex, subtrees3 + (1,-1u - 1));
  label(btex $t_{2}$ etex, subtrees4 + (1,-1u - 1));
  label(btex $t_{3}$ etex, subtrees5 + (1,-1u - 1));
  % subtrees of the 3-node
  draw subtrees0 -- (z0 + (-0.5u, -0.5u));
  draw subtrees1 -- (z0 + (0.3u,-0.5u));
  draw subtrees2 -- (z1 + (0.3u,-0.5u));
  % subtrees of the Red-Black equivalent
  draw subtrees3 -- (z4 + (-0.5u, -0.5u));
  draw subtrees4 -- (z4 + (0.5u,-0.5u));
  draw subtrees5 -- (z5 + (0.5u,-0.5u));

  draw (z[4] + (0, 0.5u))--(z5 + (-0.5u, -0.5u));
  % draw (z[6] + (0, 0.5u))--(z5 + (0.5u, -0.5u));
  draw node4 withcolor red;
  % draw node6 withcolor red;
  draw node5;
  label(btex $\approx$ etex, z3);
  label(btex $a$ etex, z0);
  label(btex $b$ etex, z1);
  draw (z2 + (-0.5u,-0.5u)) -- (z2 + (0.5u, 0.5u));
  draw (z2 + (-0.5u, 0.5u)) -- (z2 + (0.5u,-0.5u));
  % label(btex $c$ etex, z2);
  label(btex $a$ etex, z4);
  label(btex $b$ etex, z5);
  % label(btex $c$ etex, z6);
endfig;

% left-3-node as equivalent to a Red-Black subtree
beginfig(2)
  path node[];
  pair subtrees[];
  path tree[];
  numeric i;
  z[0] = (0,0);
  for i=1 upto 2:
    z[i] = z[i-1] + (u,0);
  endfor;
  z3 = z2 + (3u, 0);
  z4 = z3 + (2u,-u);
  z5 = z4 + (1.5u,1.5u);
  z6 = z5 + (1.5u,-1.5u);
  for i=0 upto 2:
    node[i] = unitsquare scaled u shifted (z[i] + (-0.5u,-0.5u));
  endfor;
  for i=4 upto 6:
    node[i] = unitsquare scaled u shifted (z[i] + (-0.5u,-0.5u));
  endfor;
  for i=0 upto 2:
    draw node[i];
  endfor;
  subtrees[1] = z[2] + (-0.75u,-0.5u) + (-0u,-u);
  % subtrees[2] = z[2] + (0.4u,-0.5u) + (0,-u);
  subtrees[2] = z[2] + (0.75u,-0.5u) + (0.5u,-u);
  subtrees[0] = subtrees[1] - (2u,0);
  subtrees[4] = z[6] + (-0.75u,-0.5u) + (-0.5u,-u);
  subtrees[5] = z[6] + (0.75u,-0.5u) + (0.5u,-u);
  subtrees[3] = z[5] + (-0.75u,-0.5u) + (-0.5u,-u);
  for i=0 upto 5:
    tree[i] = subtrees[i] -- (subtrees[i] + (0.75u,-1.5u)) -- (subtrees[i] + (-0.75u,-1.5u)) -- cycle;
    draw tree[i];
  endfor;
  label(btex $t_{1}$ etex, subtrees0 + (1,-1u - 1));
  label(btex $t_{2}$ etex, subtrees1 + (1,-1u - 1));
  label(btex $t_{3}$ etex, subtrees2 + (1,-1u - 1));
  label(btex $t_{1}$ etex, subtrees3 + (1,-1u - 1));
  label(btex $t_{2}$ etex, subtrees4 + (1,-1u - 1));
  label(btex $t_{3}$ etex, subtrees5 + (1,-1u - 1));
  % subtrees of the 3-node
  draw subtrees0 -- (z1 + (-0.3u, -0.5u));
  draw subtrees1 -- (z2 + (-0.3u,-0.5u));
  draw subtrees2 -- (z2 + (0.5u,-0.5u));
  % subtrees of the Red-Black equivalent
  draw subtrees4 -- (z6 + (-0.5u, -0.5u));
  draw subtrees5 -- (z6 + (0.5u,-0.5u));
  draw subtrees3 -- (z5 + (-0.5u,-0.5u));

  % draw (z[4] + (0, 0.5u))--(z5 + (-0.5u, -0.5u));
  draw (z[6] + (0, 0.5u))--(z5 + (0.5u, -0.5u));
  % draw node4 withcolor red;
  draw node6 withcolor red;
  draw node5;
  label(btex $\approx$ etex, z3);
  % label(btex $a$ etex, z0);
  label(btex $b$ etex, z1);
  draw (z0 + (-0.5u,-0.5u)) -- (z0 + (0.5u, 0.5u));
  draw (z0 + (-0.5u, 0.5u)) -- (z0 + (0.5u,-0.5u));
  label(btex $c$ etex, z2);
  % label(btex $a$ etex, z4);
  label(btex $b$ etex, z5);
  label(btex $c$ etex, z6);
endfig;


% left-3-node as equivalent to a Red-Black subtree
beginfig(3)
  path node[];
  pair subtrees[];
  path tree[];
  numeric i, pw;
  pw := 2;
  z[0] = (0,0);
  for i=1 upto 2:
    z[i] = z[i-1] + (u + pw,0);
  endfor;
  for i=0 upto 2:
    node[i] = unitsquare scaled u shifted (z[i] - 0.5*(u+pw,u+pw));
  endfor;
  draw node0 withpen pensquare scaled pw withcolor red;
  draw node1 withpen pensquare scaled pw;
  draw node2 withpen pensquare scaled pw withcolor red;
  label(btex $a$ etex, z0 - (0.5pw, 0.5pw + 1));
  label(btex $b$ etex, z1 - (0.5pw, 0.5pw));
  label(btex $c$ etex, z2 - (0.5pw, 0.5pw + 1));
endfig;

% motivating example of baldL
beginfig(4)
  path node[];
  path r; % right subtree
  numeric i, pw, level;
  pw := 2;
  level = 2u;
  z0 = (0,0); % q
  z1 = z0 + (0, -level) + (-2u,0) + (-pw,0); % e
  z2 = z1 + (u, 0) + (pw, 0); % m
  z3 = z1 + (0, -level) + (-2u,0); % a
  z4 = z2 + (0, -level) + (-u,0); % f
  z5 = z2 + (0, -level) + (u,0); % n
  z6 = z0 + (0, -level) + (3u, 0); % r's top vertex
  r = z6 -- (z6 + (-u,-level-0.5u-0.5pw)) -- (z6 + (u,-level-0.5u-0.5pw)) -- cycle;
  for i=0 upto 5:
    node[i] = unitsquare scaled u shifted (z[i] - 0.5*(u+pw,u+pw));
  endfor;
  % draw the links from parent to child
  draw (point 0 of node[0]) -- (point (0.625*length(node[1])) of node[1]);
  draw (point 0.25*length(node[0]) of node[0]) -- z6;
  draw (point 0 of node[1]) -- (point (0.625*length(node[3])) of node[3]);
  draw (point 0.025*length(node[2]) of node[2]) -- (point (0.625*length(node[4])) of node[4]);
  draw (point 0.25*length(node[2]) of node[2]) -- (point (0.625*length(node[5])) of node[5]);
  % draw the nodes for the trees
  for i=0 upto 5:
    draw node[i] withpen pensquare scaled pw withcolor if (i = 2): red else: black fi;
  endfor;
  draw r withpen pencircle scaled pw;
  label(btex $q$ etex, z0 - (0.5pw, 0.5pw));
  label(btex $e$ etex, z1 - (0.5pw, 0.5pw));
  label(btex $m$ etex, z2 - (0.5pw, 0.5pw));
  label(btex $a$ etex, z3 - (0.5pw, 0.5pw));
  label(btex $f$ etex, z4 - (0.5pw, 0.5pw));
  label(btex $n$ etex, z5 - (0.5pw, 0.5pw));
  label(btex $r$ etex, z6 - (0, 0.875level));
endfig;

% fig(4) with 'a' deleted
beginfig(5)
  path node[];
  path r; % right subtree
  numeric i, pw, level;
  pw := 2;
  level = 2u;
  z0 = (0,0); % q
  z1 = z0 + (0, -level) + (-2u,0) + (-pw,0); % e
  z2 = z1 + (u, 0) + (pw, 0); % m
  z3 = z1 + (0, -level) + (-2u,0); % a
  z4 = z2 + (0, -level) + (-u,0); % f
  z5 = z2 + (0, -level) + (u,0); % n
  z6 = z0 + (0, -level) + (3u, 0); % r's top vertex
  r = z6 -- (z6 + (-u,-level-0.5u-0.5pw)) -- (z6 + (u,-level-0.5u-0.5pw)) -- cycle;
  for i=0 upto 5:
    node[i] = unitsquare scaled u shifted (z[i] - 0.5*(u+pw,u+pw));
  endfor;
  % draw the links from parent to child
  draw (point 0 of node[0]) -- (point (0.625*length(node[1])) of node[1]);
  draw (point 0.25*length(node[0]) of node[0]) -- z6;
  draw (point 0 of node[1]) -- (point (0.625*length(node[3])) of node[3]);
  draw (point 0.025*length(node[2]) of node[2]) -- (point (0.625*length(node[4])) of node[4]);
  draw (point 0.25*length(node[2]) of node[2]) -- (point (0.625*length(node[5])) of node[5]);
  % draw the nodes for the trees
  for i=0 upto 5:
    draw node[i] withpen pensquare scaled pw withcolor if (i = 2): red else: black fi;
  endfor;
  draw r withpen pencircle scaled pw;
  label(btex $q$ etex, z0 - (0.5pw, 0.5pw));
  label(btex $e$ etex, z1 - (0.5pw, 0.5pw));
  label(btex $m$ etex, z2 - (0.5pw, 0.5pw));
  draw (point 0 of node[3])--(point 0.5*length(node[3]) of node[3]);
  draw (point 0.25*length(node[3]) of node[3])--(point 0.75*length(node[3]) of node[3]);
  % label(btex $a$ etex, z3 - (0.5pw, 0.5pw));
  label(btex $f$ etex, z4 - (0.5pw, 0.5pw));
  label(btex $n$ etex, z5 - (0.5pw, 0.5pw));
  label(btex $r$ etex, z6 - (0, 0.875level));
endfig;

% candidate 1 for replacing subtree rooted at 'e'
beginfig(6)
  path node[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;
  z0 = (0,0); % m
  z1 = z0 + (0, -level) + (-2u, 0) + (-pw, 0); % e
  z2 = z1 + (u, 0) + (pw, 0); % f
  z3 = z0 + (0, -level) + (2u, 0) + (pw, 0); % n
  for i=0 upto 3:
    node[i] = unitsquare scaled u shifted (z[i] - 0.5*(u+pw,u+pw));
  endfor;
  draw (point 0 of node0)--(point 0.625*length(node[1]) of node[1]);
  draw (point 0.25*length(node0) of node0)--(point 0.625*length(node[3]) of node[3]);
  % draw the nodes for the trees
  for i=0 upto 3:
    draw node[i] withpen pensquare scaled pw withcolor if (i = 2): red else: black fi;
  endfor;
  label(btex $m$ etex, z0 - (0.5pw, 0.5pw));
  label(btex $e$ etex, z1 - (0.5pw, 0.5pw));
  label(btex $f$ etex, z2 - (0.5pw, 0.5pw));
  label(btex $n$ etex, z3 - (0.5pw, 0.5pw));  
endfig;

% candidate 2 for replacing subtree rooted at 'e'
beginfig(7)
  path node[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;
  z0 = (0,0); % f
  z1 = z0 + (0, -level) + (-2u, 0) + (-pw, 0); % e
  z2 = z0 + (0, -level) + (2u, 0) + (pw, 0); % m
  z3 = z2 + (u, 0) + (pw, 0); % n
  for i=0 upto 3:
    node[i] = unitsquare scaled u shifted (z[i] - 0.5*(u+pw,u+pw));
  endfor;
  draw (point 0 of node0)--(point 0.625*length(node[1]) of node[1]);
  draw (point 0.25*length(node0) of node0)--(point 0.625*length(node[2]) of node[2]);
  % draw the nodes for the trees
  for i=0 upto 3:
    draw node[i] withpen pensquare scaled pw withcolor if (i = 3): red else: black fi;
  endfor;
  label(btex $f$ etex, z0 - (0.5pw, 0.5pw));
  label(btex $e$ etex, z1 - (0.5pw, 0.5pw));
  label(btex $m$ etex, z2 - (0.5pw, 0.5pw));
  label(btex $n$ etex, z3 - (0.5pw, 0.5pw));  
endfig;

outputtemplate:="notation-%c.%o";

beginfig(0)
  path node[];
  path subtree[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;

  z0 = (0,0);
  z1 = z0 + (0, -level);
  subtree0 = z1 -- (z1 + (-u,-2u)) -- (z1 + (u, -2u)) -- cycle;
  draw subtree0;
  draw z0--z1;
  label.top(btex del $v$ etex, z0);
  label(btex $t$ etex, z1 + (0, -1.25u));
  label.rt(btex $\equiv{\rm del\ }v{\rm\ }t$ etex, 0.5[z0,z1] + (u,0));
endfig;

% baldL l x r
beginfig(1)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;

  z0 = (0,0); % del w
  z1 = z0 + (0, -level); % x
  z2 = z1 + (-2u, -level); % vertex of l
  z3 = z1 + (2u, -level); % vertex of r
  subtree0 = z2 -- (z2 + (-u,-2u)) -- (z2 + (u, -2u)) -- cycle;
  subtree1 = z3 -- (z3 + (-u,-2u)) -- (z3 + (u, -2u)) -- cycle;
  draw subtree0;
  draw subtree1;
  node[0] = unitsquare scaled u shifted (z[1] - 0.5*(u+pw,u+pw));
  p[0] = (point 0 of node0)--z2;
  draw p0;
  z4 = point 0.5*length(p0) of p0;
  p1 = fullcircle scaled 0.5u shifted z4;
  fill p1 withcolor white;
  draw p1;
  draw (point 0.25*length(node0) of node0)--z3;
  draw subtree0; draw subtree1;
  draw node0 dashed evenly scaled 0.5;
  label(btex $x$ etex, z1 - (1,1));
  label(btex $\ell$ etex, z2 + (0, -1.25u));
  label(btex $r$ etex, z3 + (0, -1.25u));
  label.rt(btex $\equiv{\tt baldL\ }\ell{\rm\ }x{\rm\ }r$ etex, 0.5[z1,z3] + (2u,0));
endfig;

% baldR l x r
beginfig(2)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;

  z0 = (0,0); % del w
  z1 = z0 + (0, -level); % x
  z2 = z1 + (-2u, -level); % vertex of l
  z3 = z1 + (2u, -level); % vertex of r
  subtree0 = z2 -- (z2 + (-u,-2u)) -- (z2 + (u, -2u)) -- cycle;
  subtree1 = z3 -- (z3 + (-u,-2u)) -- (z3 + (u, -2u)) -- cycle;
  draw subtree0;
  draw subtree1;
  node[0] = unitsquare scaled u shifted (z[1] - 0.5*(u+pw,u+pw));
  p[0] = (point 0.25*length(node0) of node0)--z3;
  draw p0;
  z4 = point 0.5*length(p0) of p0;
  p1 = fullcircle scaled 0.5u shifted z4;
  fill p1 withcolor white;
  draw p1;
  draw (point 0 of node0)--z2;
  draw subtree0; draw subtree1;
  draw node0 dashed evenly scaled 0.5;
  label(btex $x$ etex, z1 - (1,1));
  label(btex $\ell$ etex, z2 + (0, -1.25u));
  label(btex $r$ etex, z3 + (0, -1.25u));
  label.rt(btex $\equiv{\tt baldR\ }\ell{\rm\ }x{\rm\ }r$ etex, 0.5[z1,z3] + (2u,0));
endfig;

% fuse l r
beginfig(3)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;

  z0 = (0,0); % del w
  z1 = z0 + (0, -level); % x
  z2 = z1 + (-2u, -level); % vertex of l
  z3 = z1 + (2u, -level); % vertex of r
  subtree0 = z2 -- (z2 + (-u,-2u)) -- (z2 + (u, -2u)) -- cycle;
  subtree1 = z3 -- (z3 + (-u,-2u)) -- (z3 + (u, -2u)) -- cycle;
  draw subtree0;
  draw subtree1;
  draw z3--(z3 + (0,u));
  draw z2--(z2 + (0,u));
  draw (z3 + (0,u))--(z2 + (0,u));
  draw (z3 + (0,u-3))--(z2 + (0,u-3));
  draw subtree0; draw subtree1;
  label(btex $\ell$ etex, z2 + (0, -1.25u));
  label(btex $r$ etex, z3 + (0, -1.25u));
  label.rt(btex $\equiv{\tt fuse\ }\ell{\rm\ }r$ etex, z3 + (u,0));
endfig;

beginfig(4)
  path node[];
  path subtree[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;
  subtree0 = (0,0)--(-u,-2u)--(u,-2u)--cycle;
  subtree1 = subtree0 shifted (5u,-level);
  subtree2 = subtree1 shifted (3u,0);
  z0 = point 0 of subtree1;
  z1 = point 0 of subtree2;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  for i=0 upto 2:
    draw subtree[i];
  endfor;
  drawdot (0,0) withpen pencircle scaled 3;
  draw node0 withpen pensquare scaled pw;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  label(btex $\equiv$ etex, 0.5[(0,0),point 0 of node0] + (0,-u));
endfig;

beginfig(5)
  path node[];
  path subtree[];
  numeric i, pw, level;
  pw := 2;
  level = 2u;
  subtree0 = (0,0)--(-u,-2u)--(u,-2u)--cycle;
  subtree1 = subtree0 shifted (5u,-level);
  subtree2 = subtree1 shifted (3u,0);
  z0 = point 0 of subtree1;
  z1 = point 0 of subtree2;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  for i=0 upto 2:
    draw subtree[i];
  endfor;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  drawdot (0,0) withpen pencircle scaled 3 withcolor red;
  draw node0 withpen pensquare scaled pw withcolor red;
  label(btex $\equiv$ etex, 0.5[(0,0),point 0 of node0] + (0,-u));
endfig;

outputtemplate:="downward-rule-%c.%o";

beginfig(0)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pair delta;
  pw := 2;
  level = 2u;
  subtree0 = (0,0) -- (-u,-level) -- (u, -level) -- cycle;
  subtree1 = subtree0 shifted (3u,0);
  z0 = (0,0);
  z1 = point 0 of subtree1;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  draw node0 dashed evenly scaled 0.5;
  draw subtree0; draw subtree1;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  z2 = 0.5[z0,z1] + (0,level);
  z3 = point 0.625*length(node0) of node0;
  z4 = z3 + (0,u);
  draw z3--z4;
  drawdot z0 withpen pencircle scaled 3;
  label(btex $x$ etex, z2 + (-1,-1));
  label(btex $\ell$ etex, z0 + (0, -1.25u));
  label(btex $r$ etex, z1 + (0, -1.25u));
  label.top(btex {\tt del} $w$ etex, z4);

  delta = (7u,0);
  label(btex $\equiv$ etex, z4 + (3.5u,-u));
  node1 = node0 shifted (delta + (0, 2u));
  subtree2 = subtree0 shifted delta; %(delta + (0,-2u));
  subtree3 = subtree1 shifted delta;
  draw node1 dashed evenly scaled 0.5;
  draw subtree2; draw subtree3;
  p0 = (point 0 of node1)--(point 0 of subtree2);
  z5 = point 0.25*length(p0) of p0;
  z6 = point 0.8*length(p0) of p0;
  p1 = fullcircle scaled 0.5u shifted z5;
  draw (point 0.25*length(node1) of node1)--(point 0 of subtree3);
  drawdot (point 0 of subtree2) withpen pencircle scaled 3;
  p2 = (z6 + (-u,0.1u))--(z6 + (u,0.1u));
  p3 = (z6 + (-2u,0.85u))--(z6 + (2u,0.85u));
  draw (p0 cutafter p3);
  draw (p0 cutbefore p2);
  draw p1;
  fill p1 withcolor white;
  label(btex $x$ etex, z2 + (-1,-1) + (0,2u) + delta);
  label(btex $\ell$ etex, z0 + (0, -1.25u) + delta);% + (0,-2u));
  label(btex $r$ etex, z1 + (0, -1.25u) + delta);
  label(btex {\tt del} $w$ etex, z6 + (0,0.5u));
endfig;

beginfig(1)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pair delta;
  pw := 2;
  level = 2u;
  subtree0 = (0,0) -- (-u,-level) -- (u, -level) -- cycle;
  subtree1 = subtree0 shifted (3u,0);
  z0 = (0,0);
  z1 = point 0 of subtree1;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  draw node0 dashed evenly scaled 0.5;
  draw subtree0; draw subtree1;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  z2 = 0.5[z0,z1] + (0,level);
  z3 = point 0.625*length(node0) of node0;
  z4 = z3 + (0,u);
  draw z3--z4;
  drawdot z0 withpen pencircle scaled 3 withcolor red;
  label(btex $x$ etex, z2 + (-1,-1));
  label(btex $\ell$ etex, z0 + (0, -1.25u));
  label(btex $r$ etex, z1 + (0, -1.25u));
  label.top(btex {\tt del} $w$ etex, z4);

  delta = (7u,0);
  label(btex $\equiv$ etex, z4 + (3.5u,-u));
  node1 = node0 shifted (delta + (0, 2u));
  subtree2 = subtree0 shifted delta; %(delta + (0,-2u));
  subtree3 = subtree1 shifted delta;
  draw node1 dashed evenly scaled 0.5;
  draw subtree2; draw subtree3;
  p0 = (point 0 of node1)--(point 0 of subtree2);
  z5 = point 0.25*length(p0) of p0;
  z6 = point 0.8*length(p0) of p0;
  p1 = fullcircle scaled 0.5u shifted z5;
  draw (point 0.25*length(node1) of node1)--(point 0 of subtree3);
  p2 = (z6 + (-u,0.1u))--(z6 + (u,0.1u));
  p3 = (z6 + (-2u,0.85u))--(z6 + (2u,0.85u));
  draw (p0 cutafter p3);
  draw (p0 cutbefore p2);
  drawdot (point 0 of subtree2) withpen pencircle scaled 3 withcolor red;
  label(btex $x$ etex, z2 + (-1,-1) + (0,2u) + delta);
  label(btex $\ell$ etex, z0 + (0, -1.25u) + delta);% + (0,-2u));
  label(btex $r$ etex, z1 + (0, -1.25u) + delta);
  label(btex {\tt del} $w$ etex, z6 + (0,0.5u));
endfig;

beginfig(2)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pair delta;
  pw := 2;
  level = 2u;
  subtree0 = (0,0) -- (-u,-level) -- (u, -level) -- cycle;
  subtree1 = subtree0 shifted (3u,0);
  z0 = (0,0);
  z1 = point 0 of subtree1;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  draw node0 dashed evenly scaled 0.5;
  draw subtree0; draw subtree1;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  z2 = 0.5[z0,z1] + (0,level);
  z3 = point 0.625*length(node0) of node0;
  z4 = z3 + (0,u);
  draw z3--z4;
  drawdot z1 withpen pencircle scaled 3;
  label(btex $x$ etex, z2 + (-1,-1));
  label(btex $\ell$ etex, z0 + (0, -1.25u));
  label(btex $r$ etex, z1 + (0, -1.25u));
  label.top(btex {\tt del} $y$ etex, z4);

  delta = (7u,0);
  label(btex $\equiv$ etex, z4 + (3.5u,-u));
  node1 = node0 shifted (delta + (0, 2u));
  subtree2 = subtree0 shifted delta; %(delta + (0,-2u));
  subtree3 = subtree1 shifted delta;
  draw node1 dashed evenly scaled 0.5;
  draw subtree2; draw subtree3;
  p0 = (point 0.25*length(node1) of node1)--(point 0 of subtree3);
  z5 = point 0.25*length(p0) of p0;
  z6 = point 0.8*length(p0) of p0;
  p1 = fullcircle scaled 0.5u shifted z5;
  draw (point 0 of node1)--(point 0 of subtree2);
  drawdot (point 0 of subtree3) withpen pencircle scaled 3;
  p2 = (z6 + (-u,0.1u))--(z6 + (u,0.1u));
  p3 = (z6 + (-2u,0.85u))--(z6 + (2u,0.85u));
  draw (p0 cutafter p3);
  draw (p0 cutbefore p2);
  draw p1;
  fill p1 withcolor white;
  label(btex $x$ etex, z2 + (-1,-1) + (0,2u) + delta);
  label(btex $\ell$ etex, z0 + (0, -1.25u) + delta);% + (0,-2u));
  label(btex $r$ etex, z1 + (0, -1.25u) + delta);
  label(btex {\tt del} $y$ etex, z6 + (0,0.5u));
endfig;

beginfig(3)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pair delta;
  pw := 2;
  level = 2u;
  subtree0 = (0,0) -- (-u,-level) -- (u, -level) -- cycle;
  subtree1 = subtree0 shifted (3u,0);
  z0 = (0,0);
  z1 = point 0 of subtree1;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  draw node0 dashed evenly scaled 0.5;
  draw subtree0; draw subtree1;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  z2 = 0.5[z0,z1] + (0,level);
  z3 = point 0.625*length(node0) of node0;
  z4 = z3 + (0,u);
  draw z3--z4;
  drawdot z1 withpen pencircle scaled 3 withcolor red;
  label(btex $x$ etex, z2 + (-1,-1));
  label(btex $\ell$ etex, z0 + (0, -1.25u));
  label(btex $r$ etex, z1 + (0, -1.25u));
  label.top(btex {\tt del} $y$ etex, z4);

  delta = (7u,0);
  label(btex $\equiv$ etex, z4 + (3.5u,-u));
  node1 = node0 shifted (delta + (0, 2u));
  subtree2 = subtree0 shifted delta; %(delta + (0,-2u));
  subtree3 = subtree1 shifted delta;
  draw node1 dashed evenly scaled 0.5;
  draw subtree2; draw subtree3;
  p0 = (point 0.25*length(node1) of node1)--(point 0 of subtree3);
  z5 = point 0.25*length(p0) of p0;
  z6 = point 0.8*length(p0) of p0;
  p1 = fullcircle scaled 0.5u shifted z5;
  draw (point 0 of node1)--(point 0 of subtree2);
  p2 = (z6 + (-u,0.1u))--(z6 + (u,0.1u));
  p3 = (z6 + (-2u,0.85u))--(z6 + (2u,0.85u));
  draw (p0 cutafter p3);
  draw (p0 cutbefore p2);
  drawdot (point 0 of subtree3) withpen pencircle scaled 3 withcolor red;
  label(btex $x$ etex, z2 + (-1,-1) + (0,2u) + delta);
  label(btex $\ell$ etex, z0 + (0, -1.25u) + delta);% + (0,-2u));
  label(btex $r$ etex, z1 + (0, -1.25u) + delta);
  label(btex {\tt del} $y$ etex, z6 + (0,0.5u));
endfig;

beginfig(4)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pair delta;
  pw := 2;
  level = 2u;
  subtree0 = (0,0) -- (-u,-level) -- (u, -level) -- cycle;
  subtree1 = subtree0 shifted (3u,0);
  z0 = (0,0);
  z1 = point 0 of subtree1;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  draw node0 dashed evenly scaled 0.5;
  draw subtree0; draw subtree1;
  draw (point 0 of node0)--z0;
  draw (point 0.25*length(node0) of node0)--z1;
  z2 = 0.5[z0,z1] + (0,level);
  z3 = point 0.625*length(node0) of node0;
  z4 = z3 + (0,u);
  draw z3--z4;
  label(btex $x$ etex, z2 + (-1,-1));
  label(btex $\ell$ etex, z0 + (0, -1.25u));
  label(btex $r$ etex, z1 + (0, -1.25u));
  label.top(btex {\tt del} $x$ etex, z4);

  delta = (7u,0);
  label(btex $\equiv$ etex, z4 + (3.5u,-u));
  node1 = node0 shifted (delta + (0, 2u));
  subtree2 = subtree0 shifted delta;
  subtree3 = subtree1 shifted delta;
  z5 = point 0 of subtree2;
  z6 = point 0 of subtree3;
  draw z5--(z5 + (0,u))--(z6 + (0, u))--z6;
  draw (z5 + (0,u-3))--(z6 + (0, u-3));
  draw subtree2; draw subtree3;
  label(btex $\ell$ etex, z0 + (0, -1.25u) + delta);% + (0,-2u));
  label(btex $r$ etex, z1 + (0, -1.25u) + delta);
endfig;

beginfig(5)
  path node[];
  path subtree[];
  path p[];
  numeric i, pw, level;
  pair delta;
  pw := 2;
  level = 2u;
  subtree0 = (0,0) -- (-u,-level) -- (u, -level) -- cycle;
  subtree1 = subtree0 shifted (3u,0);
  z0 = (0,0);
  z1 = point 0 of subtree1;
  node[0] = unitsquare scaled u shifted (0.5[z0,z1] + (0,level) - 0.5*(u+pw,u+pw));
  draw node0;
  draw (point 0 of node0)--(point 0.5*length(node0) of node0);
  draw (point 0.25*length(node0) of node0)--(point 0.75*length(node0) of node0);
  z3 = point 0.625*length(node0) of node0;
  z4 = z3 + (0,u);
  draw z3--z4;
  label.top(btex {\tt del} $x$ etex, z4);

  delta = (7u,0);
  label(btex $\equiv$ etex, z4 + (3.5u,-u));
  node1 = node0 shifted delta;
  draw (point 0 of node1)--(point 0.5*length(node1) of node1);
  draw (point 0.25*length(node1) of node1)--(point 0.75*length(node1) of node1);
  draw node1;
endfig;


end;
