% This function added an elliptical shape array of mass
% @param radX = Horizontal
%        radY = Vertical radius
%        theta = rotation angle
function AddEllipAtomicArray(radX, radY, theta, X0, Y0, VX0, VY0, InitDist, Temp, Type)
global C
global x y AtomSpacing
global nAtoms
global AtomType Vx Vy Mass0 Mass2 Mass1

if Type == 0
    Mass = Mass0;
elseif Type == 2
    Mass = Mass2;
else
    Mass = Mass1;
end

L = (2*radX - 1) * AtomSpacing;
W = (2*radY - 1) * AtomSpacing;

xp(1, :) = linspace(-L/2, L/2, 2*radX);
yp(1, :) = linspace(-W/2, W/2, 2*radY);

numAtoms = 0;
for i = 1:2*radX
    for j = 1:2*radY
        if xp(i)^2/ (radX * AtomSpacing)^2 + yp(j)^2/(radY * AtomSpacing)^2 <= 1
            numAtoms = numAtoms+1;
            % Apply rotation matrix [cos -sin; sin cos]
            x(nAtoms + numAtoms) = xp(i)*cos(theta) - yp(j)*sin(theta);
            y(nAtoms  + numAtoms) = xp(i)*sin(theta) + yp(j)*cos(theta);
        else
            i
            j
        end
    end
end


x(nAtoms + 1:nAtoms + numAtoms) = x(nAtoms + 1:nAtoms + numAtoms) + ...
    (rand(1, numAtoms) - 0.5) * AtomSpacing * InitDist + X0;
y(nAtoms + 1:nAtoms + numAtoms) = y(nAtoms + 1:nAtoms + numAtoms) + ...
    (rand(1, numAtoms) - 0.5) * AtomSpacing * InitDist + Y0;

AtomType(nAtoms + 1:nAtoms + numAtoms) = Type;

if Temp == 0
    Vx(nAtoms + 1:nAtoms + numAtoms) = 0;
    Vy(nAtoms + 1:nAtoms + numAtoms) = 0;
else
    std0 = sqrt(C.kb * Temp / Mass);

    Vx(nAtoms + 1:nAtoms + numAtoms) = std0 * randn(1, numAtoms);
    Vy(nAtoms + 1:nAtoms + numAtoms) = std0 * randn(1, numAtoms);
end

Vx(nAtoms + 1:nAtoms + numAtoms) = Vx(nAtoms + 1:nAtoms + numAtoms) - ...
    mean(Vx(nAtoms + 1:nAtoms + numAtoms)) + VX0;
Vy(nAtoms + 1:nAtoms + numAtoms) = Vy(nAtoms + 1:nAtoms + numAtoms) - ...
    mean(Vy(nAtoms + 1:nAtoms + numAtoms)) + VY0;

nAtoms = nAtoms + numAtoms;

end
