classdef ToolKnotenpotentialanalyse < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1          matlab.ui.Figure
        menue            matlab.ui.container.Menu
        bier             matlab.ui.container.Menu
        kachlerpkw       matlab.ui.container.Menu
        QuellenMenu      matlab.ui.container.Menu
        text2            matlab.ui.control.Label
        matrixA          matlab.ui.control.Table
        dimensionEnter   matlab.ui.control.Button
        stromVektor      matlab.ui.control.Table
        text3            matlab.ui.control.Label
        exit             matlab.ui.control.Button
        text4            matlab.ui.control.Label
        text5            matlab.ui.control.Label
        SOLVE            matlab.ui.control.Button
        text7            matlab.ui.control.Label
        spannungsVektor  matlab.ui.control.Table
        dimension        matlab.ui.control.NumericEditField
        RESET            matlab.ui.control.Button
        LampLabel        matlab.ui.control.Label
        Lamp             matlab.ui.control.Lamp
        Label            matlab.ui.control.Label
        Lamp_2           matlab.ui.control.Lamp
        Label_2          matlab.ui.control.Label
        Lamp_3           matlab.ui.control.Lamp
        Image            matlab.ui.control.Image
        Image2           matlab.ui.control.Image
        Image3           matlab.ui.control.Image
        leitwert         matlab.ui.control.Image
        stromvek         matlab.ui.control.Image
        HELPSwitchLabel  matlab.ui.control.Label
        HELPSwitch       matlab.ui.control.ToggleSwitch
        Image4           matlab.ui.control.Image
    end

    
    methods (Access = private)
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function Test2_OpeningFcn(app)

%             % This function has no output args, see OutputFcn.
%             % hObject    handle to figure
%             % eventdata  reserved - to be defined in a future version of MATLAB
%             % handles    structure with handles and user data (see GUIDATA)
%             % varargin   command line arguments to Test2 (see VARARGIN)
%             
%             % Choose default command line output for Test2
%             app.output = hObject;
%             
%             % Update handles structure
%             guidata(hObject, handles);
              app.matrixA.BackgroundColor = [1 1 1];
              app.stromVektor.BackgroundColor = [1 1 1];
              app.spannungsVektor.BackgroundColor = [1 1 1];
              app.matrixA.ColumnFormat = {'numeric' 'numeric' 'numeric' 'numeric' 'numeric' [] [] [] [] [] [] [] [] [] [] [] [] [] [] []};
              app.stromVektor.ColumnFormat = {'numeric' []};
              app.spannungsVektor.ColumnFormat = {'numeric' [] [] []};
        end

        % Button pushed function: SOLVE
        function SOLVE_Callback(app, event)
            % hObject    handle to SOLVE (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            ac = app.matrixA.Data;
            ic = app.stromVektor.Data;
         
            emptyIndex = cellfun('isempty', ac);     % Find indices of empty cells
            ac(emptyIndex) = {0};                    % Fill empty cells with 0
            
            emptyIndex = cellfun('isempty', ic);     % Find indices of empty cells
            ic(emptyIndex) = {0};                    % Fill empty cells with 0
        
            %a = cell2mat(ac)
            %i = cell2mat(ic)
            
            A = zeros(app.dimension.Value);
            I = zeros(app.dimension.Value,1);
            
            A = cell2mat(ac);
            I = cell2mat(ic);
            
           if rank(A) ~= app.dimension.Value
               f = warndlg('Rang der Leitwertmatrix entspricht nicht der eingegeben Dimension, nicht eindeutig lÃ¶sbar','OBACHT');
               RESETButtonPushed(app,event);
               dimensionEnter_Callback(app,event);
               return
           end
           
           try
                U = linsolve(A,I)
     
                set(app.spannungsVektor,'Data',U,'ColumnFormat',{'long'})
           catch
               f = warndlg('Hoppla, da ist was schiefgelaufen!!','OBACHT');
               RESETButtonPushed(app,event);
               dimensionEnter_Callback(app,event);
               return
           end
            
            %U = round(U');
            app.Lamp.Color = 'green';
        end

        % Menu selected function: bier
        function bier_Callback(app, event)
            % hObject    handle to bier (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            line{2}='Wir verordnen, setzen und wollen mit dem Rat unserer Landschaft, da forthin überall im Fürstentum Bayern sowohl auf dem lande wie auch in unseren Städten und Märkten, die kein besondere Ordnung dafür haben, von Michaeli bis Georgi ein Maß (bayerische = 1,069 Liter) oder ein Kopf (halbkugelförmiges Geschirr für Flüssigkeiten = nicht ganz eine Maß) Bier für nicht mehr als einen Pfennig Münchener Währung und von Georgi bis Michaeli die MaßŸfür nicht mehr als zwei Pfennig derselben Währung, der Kopf für nicht mehr als drei Heller (Heller = gewöhnlich ein halber Pfennig) bei Androhung unten angeführter Strafe gegeben und ausgeschenkt werden soll. Wo aber einer nicht Märzen-, sondern anderes Bier brauen oder sonstwie haben würde, soll er es keineswegs höher als um einen Pfennig die Maß ausschenken und verkaufen. Ganz besonders wollen wir, dass forthin allenthalben in unseren Städten, Märkten und auf dem Lande zu keinem Bier mehr Stücke als allein Gersten, Hopfen und Wasser verwendet und gebraucht werden sollen. Wer diese unsere Anordnung wissentlich übertritt und nicht einhält, dem soll von seiner Gerichtsobrigkeit zur Strafe dieses Faß Bier, so oft es vorkommt, unnachsichtlich weggenommen werden. Wo jedoch ein Gauwirt von einem Bierbrau in unseren Städten, Märkten oder auf dem Lande einen, zwei oder drei Eimer (= enthält 60 MaßŸ) Bier kauft und wieder ausschenkt an das gemeine Bauernvolk, soll ihm allein und sonst niemandem erlaubt und unverboten sein, die Maß oder den Kopf Bier um einen Heller teurer als oben vorgeschrieben ist, zu geben und auszuschenken.';
            line{4} = 'Gegeben von Wilhelm IV.';
            line{5} = 'Herzog in Bayern';
            line{6} = 'am Georgitag zu Ingolstadt anno 1516';
            msgbox(line,'Reihnheitsgebot 1516 in Ingoldstadt','none');
        end

        % Button pushed function: dimensionEnter
        function dimensionEnter_Callback(app, event)
            % hObject    handle to dimensionEnter (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
               currChar = get(app.figure1,'CurrentCharacter');
                if isequal(currChar,char(13)) %char(13) == enter key
       %call the pushbutton callback
                end
            
            dataA = cell(app.dimension.Value,app.dimension.Value);
            dataI = cell(app.dimension.Value,1);
            dataU = cell(app.dimension.Value,1);
            
            set(app.matrixA, 'Data', dataA);
            set(app.stromVektor, 'Data', dataI);
            set(app.spannungsVektor, 'Data', dataU);
            set(app.spannungsVektor,'ColumnWidth',{298});
        end

        % Button pushed function: exit
        function exit_Callback(app, event)
            % hObject    handle to exit (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            closereq
        end

        % Menu selected function: kachlerpkw
        function kachlerpkw_Callback(app, event)
            % hObject    handle to kachlerpkw (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            line{1} = 'Beerware by Karl Wiesmayer';
            line{2} = 'aka KachlerPKW';
            line{3} = 'Mai/2019';
            line{5} = 'Für weitere Informationen zur Beerware:';
            line{6} = 'https://de.wikipedia.org/wiki/Beerware (Stand Mai/2019)';
            msgbox(line,'Beeware Rights','none');
        end

        % Cell edit callback: matrixA
        function matrixA_CellEditCallback(app, event)
            % hObject    handle to matrixA (see GCBO)
            % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
            %	Indices: row and column indices of the cell(s) edited
            %	PreviousData: previous data for the cell(s) edited
            %	EditData: string(s) entered by the user
            %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
            %	Error: error string when failed to convert EditData to appropriate value for Data
            % handles    structure with handles and user data (see GUIDATA)
             dimension = app.dimension.Value;
             dataMatrix = app.matrixA.Data;
             app.Lamp_2.Color = 'green';
            
           
        end

        % Cell edit callback: stromVektor
        function stromVektor_CellEditCallback(app, event)
            % hObject    handle to stromVektor (see GCBO)
            % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
            %	Indices: row and column indices of the cell(s) edited
            %	PreviousData: previous data for the cell(s) edited
            %	EditData: string(s) entered by the user
            %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
            %	Error: error string when failed to convert EditData to appropriate value for Data
            % handles    structure with handles and user data (see GUIDATA)
            dimension = app.dimension.Value;
            dataMatrix = app.stromVektor.Data;
            app.Lamp_3.Color = 'green';
            
        end

        % Value changed function: dimension
        function dimensionValueChanged(app, event)
            value = app.dimension.Value;
            
        end

        % Cell edit callback: spannungsVektor
        function spannungsVektorCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            
        end

        % Button pushed function: RESET
        function RESETButtonPushed(app, event)
            app.matrixA.Data = {};
            app.stromVektor.Data = {};
            app.spannungsVektor.Data ={};
            %app.dimension.Value = 0;
            dimensionEnter_Callback(app,event);
            app.Lamp.Color = 'red';
            app.Lamp_2.Color = 'red';
            app.Lamp_3.Color = 'red';
        end

        % Callback function
        function BeerwareMenuSelected(app, event)
            line{1} = 'Beerware by Karl Wiesmayer';
            line{2} = 'aka KachlerPKW';
            line{3} = 'Mai/2019';
            line{5} = 'Für weitere Informationen zur Beerware:';
            line{6} = 'https://de.wikipedia.org/wiki/Beerware (Stand Mai/2019)';
            msgbox(line,'Beeware Rights','none');
        end

        % Image clicked function: leitwert
        function leitwertImageClicked(app, event)
            
        end

        % Image clicked function: stromvek
        function stromvekImageClicked(app, event)
            
        end

        % Value changed function: HELPSwitch
        function HELPSwitchValueChanged(app, event)
            value = app.HELPSwitch.Value;
            if ( strcmpi(value,'on') )
                app.stromvek.Visible = 'on';
                app.leitwert.Visible = 'on';
            else
                app.stromvek.Visible = 'off';
                app.leitwert.Visible = 'off';
            end
                
        end

        % Menu selected function: QuellenMenu
        function QuellenMenuSelected(app, event)
            line{1} = 'Bilder:'
            line{2} = 'https://de.wikipedia.org/wiki/Knotenpotentialverfahren (Stand 23.05.2019)'
            line{4} = 'Programmieren:';
            line{5} = 'https://de.mathworks.com/products/matlab.html'
            msgbox(line,'Quellen','none');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create figure1 and hide until all components are created
            app.figure1 = uifigure('Visible', 'off');
            app.figure1.Color = [1 1 1];
            app.figure1.Position = [312 84 969 650];
            app.figure1.Name = 'Tool für Knotenpotentialanalyse';

            % Create menue
            app.menue = uimenu(app.figure1);
            app.menue.Separator = 'on';
            app.menue.Text = 'Menü';

            % Create bier
            app.bier = uimenu(app.menue);
            app.bier.MenuSelectedFcn = createCallbackFcn(app, @bier_Callback, true);
            app.bier.Accelerator = 'B';
            app.bier.Text = 'Reinheitsgebot';

            % Create kachlerpkw
            app.kachlerpkw = uimenu(app.menue);
            app.kachlerpkw.MenuSelectedFcn = createCallbackFcn(app, @kachlerpkw_Callback, true);
            app.kachlerpkw.Accelerator = 'C';
            app.kachlerpkw.Text = 'Copyright';

            % Create QuellenMenu
            app.QuellenMenu = uimenu(app.menue);
            app.QuellenMenu.MenuSelectedFcn = createCallbackFcn(app, @QuellenMenuSelected, true);
            app.QuellenMenu.Accelerator = 'Q';
            app.QuellenMenu.Text = 'Quellen';

            % Create text2
            app.text2 = uilabel(app.figure1);
            app.text2.HorizontalAlignment = 'center';
            app.text2.VerticalAlignment = 'top';
            app.text2.FontName = 'Arial';
            app.text2.FontSize = 20;
            app.text2.FontColor = [0.302 0.7451 0.9333];
            app.text2.Position = [50 550 316 31];
            app.text2.Text = 'Dimension der Leitwertmatrix : ';

            % Create matrixA
            app.matrixA = uitable(app.figure1);
            app.matrixA.ColumnName = '';
            app.matrixA.ColumnWidth = {'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto'};
            app.matrixA.RowName = '';
            app.matrixA.ColumnEditable = [true true true true true true true true true true true true true true true true true true true true];
            app.matrixA.RowStriping = 'off';
            app.matrixA.CellEditCallback = createCallbackFcn(app, @matrixA_CellEditCallback, true);
            app.matrixA.FontSize = 10;
            app.matrixA.Position = [92 299 272 167];

            % Create dimensionEnter
            app.dimensionEnter = uibutton(app.figure1, 'push');
            app.dimensionEnter.ButtonPushedFcn = createCallbackFcn(app, @dimensionEnter_Callback, true);
            app.dimensionEnter.FontSize = 10;
            app.dimensionEnter.Position = [491 549 99 34];
            app.dimensionEnter.Text = 'Enter';

            % Create stromVektor
            app.stromVektor = uitable(app.figure1);
            app.stromVektor.ColumnName = '';
            app.stromVektor.ColumnWidth = {'auto', 'auto'};
            app.stromVektor.RowName = '';
            app.stromVektor.ColumnEditable = [true false];
            app.stromVektor.RowStriping = 'off';
            app.stromVektor.CellEditCallback = createCallbackFcn(app, @stromVektor_CellEditCallback, true);
            app.stromVektor.FontSize = 10;
            app.stromVektor.Position = [564 300 87 164];

            % Create text3
            app.text3 = uilabel(app.figure1);
            app.text3.HorizontalAlignment = 'center';
            app.text3.VerticalAlignment = 'top';
            app.text3.FontName = 'Arial';
            app.text3.FontSize = 17;
            app.text3.FontColor = [0.302 0.7451 0.9333];
            app.text3.Position = [135 481 186 32];
            app.text3.Text = 'Leitwertmatrix A';

            % Create exit
            app.exit = uibutton(app.figure1, 'push');
            app.exit.ButtonPushedFcn = createCallbackFcn(app, @exit_Callback, true);
            app.exit.BackgroundColor = [1 1 1];
            app.exit.FontName = 'Comic Sans MS';
            app.exit.FontSize = 13;
            app.exit.Position = [845 17 75 33];
            app.exit.Text = 'EXIT';

            % Create text4
            app.text4 = uilabel(app.figure1);
            app.text4.BackgroundColor = [0 1 1];
            app.text4.HorizontalAlignment = 'center';
            app.text4.VerticalAlignment = 'top';
            app.text4.FontName = 'SansSerif';
            app.text4.FontSize = 20;
            app.text4.FontColor = [1 0 1];
            app.text4.Position = [-1 606 971 32];
            app.text4.Text = 'Tool zur Lösung von Linearen Gleichungssystemen n-ter Ordung für die Knotenpotentialanalyse';

            % Create text5
            app.text5 = uilabel(app.figure1);
            app.text5.HorizontalAlignment = 'center';
            app.text5.VerticalAlignment = 'top';
            app.text5.FontName = 'Arial';
            app.text5.FontSize = 17;
            app.text5.FontColor = [0.302 0.7451 0.9333];
            app.text5.Position = [521 481 162 30];
            app.text5.Text = 'Strommatrix I';

            % Create SOLVE
            app.SOLVE = uibutton(app.figure1, 'push');
            app.SOLVE.ButtonPushedFcn = createCallbackFcn(app, @SOLVE_Callback, true);
            app.SOLVE.BackgroundColor = [0 1 1];
            app.SOLVE.FontName = 'Arial';
            app.SOLVE.FontSize = 20;
            app.SOLVE.FontColor = [0.49 0.18 0.56];
            app.SOLVE.Position = [736 318 201 128];
            app.SOLVE.Text = 'SOLVE';

            % Create text7
            app.text7 = uilabel(app.figure1);
            app.text7.HorizontalAlignment = 'center';
            app.text7.VerticalAlignment = 'top';
            app.text7.FontName = 'Arial';
            app.text7.FontSize = 23;
            app.text7.FontColor = [0.302 0.7451 0.9333];
            app.text7.Position = [285 138 227 51];
            app.text7.Text = 'Knotenpotentiale U:';

            % Create spannungsVektor
            app.spannungsVektor = uitable(app.figure1);
            app.spannungsVektor.ColumnName = '';
            app.spannungsVektor.ColumnWidth = {'auto', 'auto', 'auto', 'auto'};
            app.spannungsVektor.RowName = '';
            app.spannungsVektor.ColumnEditable = [false false false false];
            app.spannungsVektor.RowStriping = 'off';
            app.spannungsVektor.CellEditCallback = createCallbackFcn(app, @spannungsVektorCellEdit, true);
            app.spannungsVektor.FontSize = 10;
            app.spannungsVektor.Position = [525 88 301 150];

            % Create dimension
            app.dimension = uieditfield(app.figure1, 'numeric');
            app.dimension.Limits = [0 20];
            app.dimension.ValueChangedFcn = createCallbackFcn(app, @dimensionValueChanged, true);
            app.dimension.Position = [365 554 120 22];

            % Create RESET
            app.RESET = uibutton(app.figure1, 'push');
            app.RESET.ButtonPushedFcn = createCallbackFcn(app, @RESETButtonPushed, true);
            app.RESET.BackgroundColor = [1 1 1];
            app.RESET.FontName = 'Comic Sans MS';
            app.RESET.FontSize = 13;
            app.RESET.Position = [736 17 75 33];
            app.RESET.Text = {'RESET'; ''};

            % Create LampLabel
            app.LampLabel = uilabel(app.figure1);
            app.LampLabel.HorizontalAlignment = 'right';
            app.LampLabel.Position = [864 552 25 22];
            app.LampLabel.Text = {''; ''};

            % Create Lamp
            app.Lamp = uilamp(app.figure1);
            app.Lamp.Position = [904 545 36 36];
            app.Lamp.Color = [1 0 0];

            % Create Label
            app.Label = uilabel(app.figure1);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [261 489 25 22];
            app.Label.Text = '';

            % Create Lamp_2
            app.Lamp_2 = uilamp(app.figure1);
            app.Lamp_2.Position = [301 489 20 20];
            app.Lamp_2.Color = [1 0 0];

            % Create Label_2
            app.Label_2 = uilabel(app.figure1);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Position = [623 487 25 22];
            app.Label_2.Text = '';

            % Create Lamp_3
            app.Lamp_3 = uilamp(app.figure1);
            app.Lamp_3.Position = [663 487 20 20];
            app.Lamp_3.Color = [1 0 0];

            % Create Image
            app.Image = uiimage(app.figure1);
            app.Image.Position = [-1 17 192 129];
            app.Image.ImageSource = '52793128_2198620136921759_3087886855086014464_o.jpg';

            % Create Image2
            app.Image2 = uiimage(app.figure1);
            app.Image2.Position = [392 320 100 125];
            app.Image2.ImageSource = 'Bildschirmfoto 2019-05-23 um 00.42.36.png';

            % Create Image3
            app.Image3 = uiimage(app.figure1);
            app.Image3.Position = [511 365 27 34];
            app.Image3.ImageSource = 'Bildschirmfoto 2019-05-23 um 00.49.38.png';

            % Create leitwert
            app.leitwert = uiimage(app.figure1);
            app.leitwert.ImageClickedFcn = createCallbackFcn(app, @leitwertImageClicked, true);
            app.leitwert.Visible = 'off';
            app.leitwert.Position = [106 291 243 183];
            app.leitwert.ImageSource = 'Bildschirmfoto 2019-05-23 um 00.49.51.png';

            % Create stromvek
            app.stromvek = uiimage(app.figure1);
            app.stromvek.ImageClickedFcn = createCallbackFcn(app, @stromvekImageClicked, true);
            app.stromvek.Visible = 'off';
            app.stromvek.Position = [558 332 100 100];
            app.stromvek.ImageSource = 'Bildschirmfoto 2019-05-23 um 00.49.45.png';

            % Create HELPSwitchLabel
            app.HELPSwitchLabel = uilabel(app.figure1);
            app.HELPSwitchLabel.HorizontalAlignment = 'center';
            app.HELPSwitchLabel.Position = [755 473 36 22];
            app.HELPSwitchLabel.Text = 'HELP';

            % Create HELPSwitch
            app.HELPSwitch = uiswitch(app.figure1, 'toggle');
            app.HELPSwitch.ValueChangedFcn = createCallbackFcn(app, @HELPSwitchValueChanged, true);
            app.HELPSwitch.Position = [763 531 20 45];

            % Create Image4
            app.Image4 = uiimage(app.figure1);
            app.Image4.Position = [820 101 100 125];
            app.Image4.ImageSource = 'Bildschirmfoto 2019-05-23 um 01.13.49.png';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ToolKnotenpotentialanalyse

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.figure1)

            % Execute the startup function
            runStartupFcn(app, @Test2_OpeningFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.figure1)
        end
    end
end