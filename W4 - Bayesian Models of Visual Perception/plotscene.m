function h=plotscene(S,edg,opt)
% h=plotscene(S,edg,opt)

if nargin<3,
  opt='o-';
end

if size(S,1)==3,
  h=plot3([S(1,edg(:,1));S(1,edg(:,2))],...
	[S(2,edg(:,1));S(2,edg(:,2))],...
	[S(3,edg(:,1));S(3,edg(:,2))],opt);
elseif size(S,1)==2,
  h=plot([S(1,edg(:,1));S(1,edg(:,2))],[S(2,edg(:,1));S(2,edg(:,2))],opt);
else
  error('S should have 2 or 3 components');
end


