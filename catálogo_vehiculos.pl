% Base de datos vehiculos con precio en pesos colombianos , Ana Sofía Angarita , Axel Cardona
% La estructura será la siguiente: vehicle(Marca, Referencia, Tipo, Precio, Año)

% Toyota (precios entre 80 y 320 millones)
vehicle(toyota, corolla, sedan, 120000000, 2023).     % 120 millones
vehicle(toyota, rav4, suv, 180000000, 2022).         % 180 millones
vehicle(toyota, hilux, pickup, 220000000, 2023).     % 220 millones
vehicle(toyota, supra, sport, 320000000, 2022).      % 320 millones

% Chevrolet (precios entre 60 y 250 millones)
vehicle(chevrolet, spark, sedan, 60000000, 2023).     % 60 millones
vehicle(chevrolet, trax, suv, 110000000, 2022).      % 110 millones
vehicle(chevrolet, silverado, pickup, 250000000, 2023). % 250 millones
vehicle(chevrolet, camaro, sport, 220000000, 2022).   % 220 millones

% BMW (precios entre 200 y 500 millones)
vehicle(bmw, serie3, sedan, 280000000, 2023).        % 280 millones
vehicle(bmw, x3, suv, 350000000, 2022).             % 350 millones
vehicle(bmw, x5, suv, 480000000, 2023).             % 480 millones
vehicle(bmw, z4, sport, 420000000, 2022).           % 420 millones

% Mazda (precios entre 90 y 180 millones)
vehicle(mazda, mazda3, sedan, 95000000, 2023).      % 95 millones
vehicle(mazda, cx5, suv, 150000000, 2022).         % 150 millones
vehicle(mazda, cx9, suv, 180000000, 2023).         % 180 millones
vehicle(mazda, mx5, sport, 160000000, 2022).       % 160 millones

% Renault (precios entre 70 y 150 millones)
vehicle(renault, logan, sedan, 70000000, 2023).     % 70 millones
vehicle(renault, duster, suv, 110000000, 2022).     % 110 millones
vehicle(renault, koleos, suv, 150000000, 2023).    % 150 millones
vehicle(renault, megane, sport, 130000000, 2022).  % 130 millones

% Predicados 

% Verifica si un vehículo está dentro del presupuesto
meet_budget(Reference, BudgetMax) :-
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.

% Genera reporte con restricción de presupuesto
generate_report(Brand, Type, Budget, Result) :-
    findall(vehicle(Brand, Ref, Type, Price, Year),
           (vehicle(Brand, Ref, Type, Price, Year), Price =< Budget),
           Filtered),
    calculate_total(Filtered, Total),
    (Total =< 1000000000 ->
        Result = Filtered
    ;
        sort_by_price(Filtered, Sorted),
        adjust_inventory(Sorted, 1000000000, Result)
    ).

% Predicados para generate_report
calculate_total([], 0).
calculate_total([vehicle(_,_,_,P,_)|T], Total) :-
    calculate_total(T, Subtotal),
    Total is P + Subtotal.

sort_by_price(Vehicles, Sorted) :-
    predsort(compare_prices, Vehicles, Sorted).

compare_prices(Order, vehicle(_,_,_,P1,_), vehicle(_,_,_,P2,_)) :-
    compare(Order, P1, P2).

adjust_inventory([], _, []).
adjust_inventory([V|Vs], Limit, [V|Result]) :-
    vehicle(_,_,_,P,_) = V,
    NewLimit is Limit - P,
    NewLimit >= 0,
    adjust_inventory(Vs, NewLimit, Result).
adjust_inventory([_|Vs], Limit, Result) :-
    adjust_inventory(Vs, Limit, Result).

% Caso 1: Toyota SUV bajo 120 millones COP
test_case_1(Result) :-
    findall(Ref, (vehicle(toyota, Ref, suv, Price, _), Price < 120000000), Result).

% Caso 2: Renault agrupados por tipo y año
test_case_2(Result) :-
    bagof((Type, Year, Ref), vehicle(renault, Ref, Type, _, Year), Result).

% Caso 3: Total de sedanes <= 500 millones COP
test_case_3(Total) :-
    findall(Price, vehicle(_, _, sedan, Price, _), Prices),
    sum_list(Prices, Total),
    Total =< 500000000.

