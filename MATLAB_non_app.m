classdef a13954_a13958_UI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        TabGroup                  matlab.ui.container.TabGroup
        InicioTab                 matlab.ui.container.Tab
        HTML_2                    matlab.ui.control.HTML
        CIRCUITOButton            matlab.ui.control.Button
        HTML_3                    matlab.ui.control.HTML
        SETUPButton               matlab.ui.control.Button
        SetupTab                  matlab.ui.container.Tab
        TitleHTML                 matlab.ui.control.HTML
        TitleHTMLInfo             matlab.ui.control.Label
        DescInfo                  matlab.ui.control.HTML
        Warning                   matlab.ui.control.HTML
        Info                      matlab.ui.control.HTML
        Success                   matlab.ui.control.HTML
        Error                     matlab.ui.control.HTML
        HTMLText                  matlab.ui.control.HTML
        Input                     matlab.ui.control.EditField
        ButtonOK                  matlab.ui.control.Button
        Slider                    matlab.ui.control.Slider
        ButtonSIM                 matlab.ui.control.Button
        ButtonNAO                 matlab.ui.control.Button
        Axe1                      matlab.ui.control.UIAxes
        CircuitoTab               matlab.ui.container.Tab
        moldura1                  matlab.ui.control.HTML
        moldura2                  matlab.ui.control.HTML
        img1                      matlab.ui.control.UIAxes
        img2                      matlab.ui.control.UIAxes
        moldura1_2                matlab.ui.control.HTML
        ForaparaafrenteLabel      matlab.ui.control.Label
        MotorWheightFWtxt         matlab.ui.control.EditField
        ForaparatrsLabel          matlab.ui.control.Label
        MotorWheightBWtxt         matlab.ui.control.EditField
        VelocidademanobraskLabel  matlab.ui.control.Label
        slowconst_vtxt            matlab.ui.control.EditField
        parametros                matlab.ui.control.Label
        moldura5                  matlab.ui.control.HTML
        informacao                matlab.ui.control.Label
        AmplitudemximaLabel       matlab.ui.control.Label
        A_maxtxt                  matlab.ui.control.EditField
        DistanciamximacmsLabel    matlab.ui.control.Label
        D_maxtxt                  matlab.ui.control.EditField
        EtapaatualLabel           matlab.ui.control.Label
        etapatxt                  matlab.ui.control.EditField
        FormadetetadaLabel        matlab.ui.control.Label
        DetectedShapetxt          matlab.ui.control.EditField
        PrecisoLabel              matlab.ui.control.Label
        Precisiontxt              matlab.ui.control.EditField
        EqEnergiaLabel            matlab.ui.control.Label
        Energytxt                 matlab.ui.control.EditField
        EqEnergiaFinalLabel       matlab.ui.control.Label
        Energyfinaltxt            matlab.ui.control.EditField
        moldura3                  matlab.ui.control.HTML
        img3                      matlab.ui.control.UIAxes
        moldura4                  matlab.ui.control.HTML
        img4                      matlab.ui.control.UIAxes
        ButtonGraphs              matlab.ui.control.Button
        NaCor                     matlab.ui.control.EditField
        Cor1                      matlab.ui.control.EditField
        Cor2                      matlab.ui.control.EditField
        Cor3                      matlab.ui.control.EditField
        Cor4                      matlab.ui.control.EditField
        Cor5                      matlab.ui.control.EditField
        Cor6                      matlab.ui.control.EditField
        FPS                       matlab.ui.control.Label
        RotationidxLabel          matlab.ui.control.Label
        RotateTest                matlab.ui.control.Button
        RotateRight               matlab.ui.control.Button
        RotateLeft                matlab.ui.control.Button
        RotationidxSave           matlab.ui.control.Button
        Circuito                  matlab.ui.control.Slider
        ErrorTab                  matlab.ui.container.Tab
        DescInfo_2                matlab.ui.control.HTML
        Error_2                   matlab.ui.control.HTML
        TitleHTML_2               matlab.ui.control.HTML
        TitleHTMLInfo_2           matlab.ui.control.Label
        HTMLText_Error            matlab.ui.control.HTML
        ButtonOK_Error            matlab.ui.control.Button
    end

    
    properties (Access = public)
        A_max = zeros(0);
        D_max = zeros(0);
        GrabOff = zeros(0);
        GrabOn = zeros(0);
        HSVColors = zeros(0);
        IP_Webcam = zeros(0);
        Midx = zeros(0);
        MotorWheightBW = zeros(0);
        MotorWheightFW = zeros(0);
        Realocating = 0;
        Rotation_Idx = zeros(0);
        buttonNAOPressed = 0;
        buttonOKPressed = 0;
        buttonSIMPressed = 0;
        colors = zeros(0);
        colorsbckp = zeros(0);
        const_v = zeros(0);
        currentColor = zeros(0);
        elev_motor = zeros(0);
        etapa = 'None';
        forma_obj = zeros(0);
        garra_base = zeros(0);
        h = zeros(0);
        hidegraphs = 1;
        im_crop_RGB = zeros(0);
        im_crop_SHAPE = zeros(0);
        left_motor = zeros(0);
        matchObjects = struct();
        myev3 = zeros(0);
        nnet = zeros(0);
        right_motor = zeros(0);
        rotation_degrees = zeros(0);
        s = zeros(0);
        slowConst_v = zeros(0);
        stats_cubo = zeros(0);
        v = zeros(0);
        vol_Ev3 = zeros(0);
        yHeight = zeros(0);
    end
    
    methods (Access = public)
        function main(app)
            while (true)
                try
                    switch app.etapa
                        case 'None'
                            app.TabGroup.SelectedTab = app.TabGroup.Children(1);
                            
                        case 'SettingUp' % NN(classificador de formas) e calibração
                            while(isempty(app.IP_Webcam))
                                SetupImAq(app);
                                drawnow;
                            end
                            while (isempty(app.garra_base))
                                SetupEv3(app);
                                drawnow;
                            end
                            while (isempty(app.HSVColors))
                                GetHSV(app);
                                drawnow;
                            end
                            while (isempty(app.MotorWheightFW))
                                CheckMotorParams(app);
                                drawnow;
                            end
                            while (isempty(app.nnet))
                                Get_NN(app);
                                drawnow;
                            end
                            app.TabGroup.SelectedTab = app.TabGroup.Children(1);
                            app.CIRCUITOButton.Enable = true;
                            
                        case 'CheckEnd' % Verifica se o circuito acabou
                            CheckEnd(app);
                            
                        case 'GetColor' % Proxima cor no percurso
                            GetColor(app, app.currentColor);
                            app.etapatxt.Value = "FindColor";
                            app.etapa = 'FindColor';
                            
                        case 'FindColor' % Procura a cor por CV
                            FindColor(app, app.left_motor, app.right_motor);
                            if (~(isempty(app.stats_cubo)))
                                playTone(app.myev3, 1800, 0.3, app.vol_Ev3);
                                app.etapatxt.Value = "GoToColor";
                                app.etapa = 'GoToColor';
                                for i = 1:6
                                    if (strcmp(char(app.colors(app.currentColor)),(char(app.(char(sprintf('Cor%d', i))).Tag))))
                                        app.Circuito.Value = i+2;
                                    end
                                end
                            end
                            
                        case 'GoToColor' % Dirige-se á cor
                            GoToColor(app);
                            FindColor(app, app.left_motor, app.right_motor);
                            if (isempty(app.stats_cubo))
                                app.etapatxt.Value = "FindColor";
                                app.etapa = 'FindColor';
                            end
                            
                        case 'SetFinalPos' % Ultimos retoques de posicionamento em modo semi-auto
                            SetFinalPos(app);
                            FindColor(app, app.left_motor, app.right_motor);
                            if (isempty(app.stats_cubo))
                                app.etapatxt.Value = "FindColor";
                                app.etapa = 'FindColor';
                            end
                            
                        case 'GetShape' % Identifica a forma presente no objeto
                            FindColor(app, app.left_motor, app.right_motor);
                            GetShape(app);
                            
                        case 'RotTest'
                            app.RotationidxLabel.Visible = true;
                            app.RotateLeft.Visible = true;
                            app.RotateRight.Visible = true;
                            app.RotationidxSave.Visible = true;
                            drawnow;
                            while (~app.buttonOKPressed)
                                drawnow;
                            end
                            app.buttonOKPressed = 0;
                            app.RotationidxLabel.Visible = false;
                            app.RotateLeft.Visible = false;
                            app.RotateRight.Visible = false;
                            app.RotationidxSave.Visible = false;
                            
                    end
                catch
                    drawnow;
                    app.TabGroup.SelectedTab = app.TabGroup.Children(4);
                    ME = MException('instrument:fwrite:opfailed', sprintf('Verifique a conexão entre o PC e o Ev3.'),...
                        'legoev3io:build:Legoev3BluetoothFailed', sprintf('Verifique a conexão entre o PC e o Ev3.'),...
                        'MATLAB:imagesci:imread:urlRead', sprintf('Verifique a conexão entre o PC e o IPCam.'));
                    app.HTMLText_Error.HTMLSource =  sprintf(['<p style= "text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 2px;">' ...
                        '%s' ...
                        '</p>'], ME.message);
                    app.buttonOKPressed = 0;
                    drawnow;
                    
                    while(~app.buttonOKPressed)
                        drawnow;
                    end
                    app.buttonOKPressed = 0;
                    
                    if (strcmpi(app.etapa, 'SettingUp'))
                        app.TabGroup.SelectedTab = app.TabGroup.Children(2);
                        app.IP_Webcam = zeros(0);
                        app.garra_base = zeros(0);
                        app.HSVColors = zeros(0);
                        app.MotorWheightFW = zeros(0);
                        app.nnet = zeros(0);
                    elseif (strcmpi(app.etapa, 'None'))
                        app.TabGroup.SelectedTab = app.TabGroup.Children(1);
                    else
                        app.TabGroup.SelectedTab = app.TabGroup.Children(3);
                    end
                end
                drawnow;
            end
        end
        
        %% Função SetupImAq (Etapa 0) >> Obter aquisição de imagem
        function SetupImAq(app)
            app.TitleHTMLInfo.Text = "[ Setup 1/5 ]  Aquisição de imagem";
            app.Success.Visible = false;
            app.Info.Visible = true;
            app.Warning.Visible = false;
            app.HTMLText.Position = [100,41,436,221];
            app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Insira o endereço IP da camara para a aquisição de imagem.' ...
                '</p>']);
            app.Input.Position = [120,134,191,45];
            app.Input.Value = '192.168.137.251';
            app.Input.Visible = true;
            app.ButtonOK.Visible = true;
            app.ButtonOK.Position = [334,134,191,45];
            drawnow;
            
            while(~app.buttonOKPressed)
                app.IP_Webcam = sprintf('http://%s:8080/shot.jpg', app.Input.Value);
                drawnow;
            end
            app.buttonOKPressed = 0;
            
            app.Info.Visible = false;
            app.Warning.Visible = true;
            app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Verifique se a IPCam e o PC estão ambos conectados á mesma rede.' ...
                '</p>']);
            app.Input.Visible = false;
            app.ButtonOK.Position = [224,117,191,45];
            app.buttonOKPressed = 0;
            drawnow;
            
            while(~app.buttonOKPressed)
                drawnow;
            end
            app.buttonOKPressed = 0;
            
            app.Info.Visible = true;
            app.Warning.Visible = false;
            app.ButtonOK.Visible = false;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Conectando o PC ao IPCam...' ...
                '</p>']);
            app.buttonOKPressed = 0;
            drawnow;
            pause(1);
            
            if(~isempty(imread(app.IP_Webcam)))
                app.Info.Visible = false;
                app.Success.Visible = true;
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Conectado com sucesso!' ...
                    '</p>']);
                drawnow;
                pause(1);
                
                app.Midx = size(imread(app.IP_Webcam), 2) / 2.00;
                app.yHeight = size(imread(app.IP_Webcam), 1);
            end
        end
        
        %% Função SetupEv3 (Etapa 0) >> Obter posicionamento ideal da garra
        function SetupEv3(app)
            
            app.TitleHTMLInfo.Text = "[ Setup 2/5 ]  Lego Mindstorm Ev3";
            app.Success.Visible = false;
            app.Warning.Visible = true;
            app.HTMLText.Position = [102,32,436,246];
            app.HTMLText.HTMLSource = sprintf(['<body style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                '<p>Verifique se os três motores (A(garra),C(motor direita),D(motor esquerda)) estão devidamente conectados.</p>' ...
                '<p>Verifique também se o Bluetooth do PC e do Ev3 estão ambos ligados.</body>' ...
                '</p>']);
            app.ButtonOK.Visible = true;
            app.ButtonOK.Position = [224,89,191,45];
            drawnow;
            
            while(~app.buttonOKPressed)
                drawnow;
            end
            app.buttonOKPressed = 0;
            app.Warning.Visible = false;
            app.Info.Visible = true;
            app.HTMLText.Position = [102,22,436,246];
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Insira o endereço Bluetooth do robô Ev3' ...
                '</p>']);
            app.Input.Position = [110,134,191,45];
            app.Input.Value = '00165381370a';
            app.Input.Visible = true;
            app.ButtonOK.Visible = true;
            app.ButtonOK.Position = [324,134,191,45];
            drawnow;
            
            while(~app.buttonOKPressed)
                drawnow;
            end
            app.buttonOKPressed = 0;
            
            app.Warning.Visible = false;
            app.Info.Visible = true;
            app.Input.Visible = false;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Volume do robô Ev3' ...
                '</p>']);
            app.Slider.Value = 20.0;
            app.Slider.Visible = true;
            app.Slider.Position = [108,162,194,3];
            app.ButtonOK.Visible = true;
            app.ButtonOK.Position = [341,126,191,45];
            drawnow;
            
            while(~app.buttonOKPressed)
                app.vol_Ev3 = app.Slider.Value;
                drawnow;
            end
            
            app.Slider.Visible = false;
            app.buttonOKPressed = 0;
            app.Input.Visible = false;
            app.ButtonOK.Visible = false;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Conectando o PC ao Ev3...' ...
                '</p>']);
            drawnow;
            
            if (exist('app.myev3', 'var')) == 1
                clear('app.myev3');
                clear app.myev3;
                delete app.myev3;
            end
            
            if (exist('legoev3', 'var')) == 1
                clear('legoev3');
                clear legoev3;
                delete legoev3;
            end
            
            app.myev3 = legoev3('bt', sprintf('%s', app.Input.Value));
            playTone(app.myev3, 500, 0.2, app.vol_Ev3); pause(0.2);
            playTone(app.myev3, 1000, 0.3, app.vol_Ev3); pause(0.3);
            
            app.Info.Visible = false;
            app.Success.Visible = true;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Conectado com sucesso!' ...
                '</p>']);
            drawnow;
            pause(1);
            
            app.left_motor = motor(app.myev3,'D');
            app.right_motor = motor(app.myev3,'C');
            app.elev_motor = motor(app.myev3,'A');
            
            start(app.left_motor); % inicializar motor esquerda
            start(app.right_motor); % inicializar motor direita
            start(app.elev_motor); % inicializar motor elevador
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Ajustando posição da garra...' ...
                '</p>']);
            drawnow;
            
            while(true)
                aux = readRotation(app.elev_motor);
                app.elev_motor.Speed = -30;
                pause(0.001)
                app.elev_motor.Speed = 0;
                if(readRotation(app.elev_motor) == aux)
                    break;
                end
            end
            
            app.garra_base = readRotation(app.elev_motor)+172;
            
            while(readRotation(app.elev_motor) ~= app.garra_base) % Posição incial elevador
                if (readRotation(app.elev_motor) > app.garra_base)
                    app.elev_motor.Speed = -(10);
                    pause(0.001)
                    app.elev_motor.Speed = 0;
                else
                    app.elev_motor.Speed = (10);
                    pause(0.001)
                    app.elev_motor.Speed = 0;
                end
            end
            
            app.Info.Visible = false;
            app.Success.Visible = true;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Garra ajustada com sucesso.' ...
                '</p>']);
            drawnow;
            pause(1);
            
            if ~(exist('.\.resources\Imaq Params\Imaq.mat', 'file')==0)
                load('.\.resources\Imaq Params\Imaq.mat',"A_max", "D_max");
            else
                A_max = str2double("55");
                D_max = str2double("73");
            end
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            app.ButtonOK.Text = "SUBMETER";
            app.ButtonOK.Visible = true;
            app.Input.Position = [134,107,168,45];
            app.ButtonOK.Position = [326,107,191,45];
            app.HTMLText.Position = [100,41,436,221];
            app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Amplitude máxima em graus captada pela camara: ' ...
                '</p>']);
            app.Input.Value = num2str(A_max);
            app.Input.Visible = true;
            drawnow;
            
            while(~app.buttonOKPressed)
                if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                    app.buttonOKPressed = 0;
                end
                drawnow;
            end
            app.A_max = str2double(app.Input.Value);
            app.buttonOKPressed = 0;
            
            app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Distancia máxima em centimetros captada pela camara: ' ...
                '</p>']);
            app.Input.Value = num2str(D_max);
            app.Input.Visible = true;
            drawnow;
            
            while(~app.buttonOKPressed)
                if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                    app.buttonOKPressed = 0;
                end
                drawnow;
            end
            app.D_max = str2double(app.Input.Value);
            app.buttonOKPressed = 0;
            app.ButtonOK.Visible = false;
            app.Input.Visible = false;
            
            A_max = app.A_max;
            D_max = app.D_max;
            save('.\.resources\Imaq Params\Imaq.mat',"A_max", "D_max");
        end
        
        %% Função GetHSV (Etapa 0) >> Obter valores de HSV através de ficheiro "HSV_Values.mat"
        function GetHSV(app)
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            app.TitleHTMLInfo.Text = "[ Setup 3/5 ]  Segmentação de Cor HSV";
            drawnow;
            
            if not(isfile('.\.resources\Hue Saturation Value\HSV_Values.mat'))
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Indique no explorador onde se encontra o ficheiro "HSV_Values.mat" para calibrar as cores.' ...
                    '</p>']);
                drawnow;
                [baseName, folder] = uigetfile({'*.mat', 'HSV Values File (*.mat)'}, 'Selecione o ficheiro "HSV_Values.mat"', 'HSV_Values.mat');
                fullFileName = fullfile(folder, baseName);
            else
                baseName = 'HSV_Values.mat';
                folder = '.\.resources\Hue Saturation Value\';
                fullFileName = fullfile(folder, baseName);
            end
            
            if(~isequal(baseName,0))
                load(fullFileName, 'HSVColors');
                app.HSVColors = HSVColors;
                app.colors = fieldnames(HSVColors);
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'O ficheiro "HSV_Values.mat" que auxilia a segmentação das cores foi encontrado. Pretende mesmo assim calibrar novas cores?' ...
                    '</p>']);
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Position = [336,118,191,45];
                app.ButtonSIM.Position = [121,118,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                end
                
                if (app.buttonSIMPressed)
                    TrainHSV(app);
                    HSVColors = zeros(0,0);
                    app.buttonSIMPressed = 0;
                    drawnow;
                end
                app.buttonNAOPressed = 0;
                
            else
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.ButtonOK.Text = "OK";
                app.ButtonOK.Visible = true;
                app.ButtonOK.Position = [224,117,191,45];
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'O ficheiro "HSV_Values.mat" não existe, pelo que será necessário calibrar as cores manualmente.' ...
                    '</p>']);
                drawnow;
                pause(1);
                
                while(~app.buttonOKPressed)
                    drawnow;
                end
                app.buttonOKPressed = 0;
                
                TrainHSV(app);
            end
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            app.ButtonSIM.Visible = true;
            app.ButtonNAO.Visible = true;
            app.HTMLText.Position = [102,32,436,246];
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 0px; text-align: justify; letter-spacing: 1px;">' ...
                'Quer testar as cores?' ...
                '</p>']);
            app.Input.Visible = false;
            app.ButtonOK.Visible = false;
            app.ButtonNAO.Visible = true;
            app.ButtonSIM.Visible = true;
            app.ButtonNAO.Position = [336,118,191,45];
            app.ButtonSIM.Position = [121,118,191,45];
            
            while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                drawnow;
            end
            
            if (app.buttonSIMPressed )
                TestHSV(app);
                app.buttonSIMPressed = 0;
                drawnow;
            end
            app.buttonNAOPressed = 0;
            
        end
        
        %% Função TrainHSV (Etapa 0) >> Calibrar as novas cores
        function TrainHSV(app)
            
            app.buttonSIMPressed = 0;
            
            Saved_img = struct();
            app.colors = zeros(0);
            
            while(~app.buttonNAOPressed)
                if (length(app.colors) == 6)
                    break;
                end
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Insira as cores que pretende adicionar ao circuito (máximo: 6 cores)? Caso não pretenda adicionar mais cores clique em "Finalizar".' ...
                    '</p>']);
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.Input.Visible = true;
                app.Input.Value = '';
                app.ButtonSIM.Text = "Guardar";
                app.ButtonNAO.Text = "Finalizar";
                app.Input.Position = [121,118,191,45];
                app.ButtonNAO.Position = [227,60,191,45];
                app.ButtonSIM.Position = [336,118,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                end
                
                if (app.buttonSIMPressed)
                    app.buttonSIMPressed = 0;
                    if (isempty(app.colors))
                        app.colors = {sprintf('%s', app.Input.Value )};
                    else
                        app.colors(length(app.colors)+1) = {sprintf('%s', app.Input.Value )};
                    end
                    app.ButtonSIM.Enable = false;
                    app.ButtonNAO.Enable = false;
                    drawnow;
                    pause(1);
                    app.ButtonSIM.Enable = true;
                    app.ButtonNAO.Enable = true;
                    drawnow;
                end
                
                if (app.buttonNAOPressed)
                    app.buttonNAOPressed = 0;
                    break;
                end
            end
            
            for cor = 1:length(app.colors)
                app.HTMLText.Position = [102,22,436,246];
                app.Axe1.Position = [0,0,0,0];
                app.Input.Visible = false;
                app.ButtonNAO.Visible = false;
                app.ButtonSIM.Visible = false;
                app.ButtonOK.Text = "OK";
                app.ButtonOK.Visible = true;
                app.ButtonOK.Position = [224,118,191,45];
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Aponte a camera para o cubo %s de maneira a que a forma fique visivel.' ...
                    '</p>'], cell2mat(upper(app.colors(cor))));
                close all;
                
                while(~app.buttonOKPressed)
                    drawnow;
                end
                app.buttonOKPressed = 0;
                
                app.ButtonOK.Visible = false;
                imgTeste = imread(app.IP_Webcam);
                app.Axe1.Visible = true;
                app.Axe1.Position = [63,71,300,185];
                if(size(imgTeste, 2) >= size(imgTeste, 1))
                    imshow(imresize(imgTeste, [size(imgTeste, 2) size(imgTeste, 2)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                else
                    imshow(imresize(imgTeste, [size(imgTeste, 1) size(imgTeste, 1)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                end
                app.HTMLText.Position = [102,53,436,246];
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                    'Pretende utilizar esta imagem?' ...
                    '</p>']);
                app.ButtonSIM.Text = "SIM";
                app.ButtonNAO.Text = "NAO";
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Position = [379,184,191,45];
                app.ButtonNAO.Position = [379,107,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed))
                    if (app.buttonNAOPressed )
                        app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                            'A aquirir nova imagem...' ...
                            '</p>']);
                        app.ButtonNAO.Enable = false;
                        app.ButtonSIM.Enable = false;
                        drawnow;
                        pause(1);
                        imgTeste = imread(app.IP_Webcam);
                        if(size(imgTeste, 2) >= size(imgTeste, 1))
                            imshow(imresize(imgTeste, [size(imgTeste, 2) size(imgTeste, 2)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                        else
                            imshow(imresize(imgTeste, [size(imgTeste, 1) size(imgTeste, 1)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                        end
                        app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                            'Pretende utilizar esta imagem?' ...
                            '</p>']);
                        app.ButtonNAO.Enable = true;
                        app.ButtonSIM.Enable = true;
                        app.buttonNAOPressed = 0;
                        drawnow;
                    end
                    drawnow;
                end
                app.buttonSIMPressed = 0;
                drawnow;
                
                Saved_img.(cell2mat(app.colors(cor))) = imgTeste;
            end
            
            if(length(app.colors)==1)
                imgTeste = Saved_img.(cell2mat(app.colors(1)));
            elseif(length(app.colors)==2)
                imgTeste = [Saved_img.(cell2mat(app.colors(1))), Saved_img.(cell2mat(app.colors(2)))];
            else
                imgTeste = [Saved_img.(cell2mat(app.colors(1))), Saved_img.(cell2mat(app.colors(2)))];
                for i = 3:2:length(app.colors)
                    if((i+1)>length(app.colors))
                        imgTeste = [imgTeste; Saved_img.(cell2mat(app.colors(i))) zeros(size(Saved_img.(cell2mat(app.colors(i))),1),size(Saved_img.(cell2mat(app.colors(i))),2),size(Saved_img.(cell2mat(app.colors(i))),3))];
                    else
                        imgTeste = [imgTeste; Saved_img.(cell2mat(app.colors(i))) Saved_img.(cell2mat(app.colors(i+1)))];
                    end
                end
            end
            
            close all;
            
            for cor = 1:length(app.colors)
                app.Axe1.Position = [0,0,0,0];
                app.ButtonOK.Visible = true;
                app.ButtonSIM.Visible = false;
                app.ButtonNAO.Visible = false;
                app.ButtonOK.Position = [227,63,191,45];
                app.HTMLText.Position = [74,52,492,247];
                app.Input.Visible = false;
                app.ButtonOK.Text = "OK";
                app.HTMLText.HTMLSource = sprintf(['<body style="text-align: center; letter-spacing: 1px;">' ...
                    '<b>Calibrar a cor %s.</b>' ...
                    '<p style="margin-top:20px"></p>'...
                    '<p>1. Selecione o campo de cores HSV;</p>'...
                    '<p>2. Ajuste os valores de HSV;</p>'...
                    '<p>3. Export >> Export Function;</p>'...
                    '<p>4. Escreva as informações pedidas.</p></body>'], cell2mat(upper(app.colors(cor))));
                colorThresholder(imgTeste);
                
                while(~app.buttonOKPressed)
                    drawnow;
                end
                app.buttonOKPressed = 0;
                app.ButtonOK.Text = "SUBMETER";
                app.Input.Position = [336,211,107,37];
                app.ButtonOK.Position = [227,92,191,45];
                app.HTMLText.Position = [182,136,282,101];
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-align: justify; letter-spacing: 1px;">' ...
                    'Channel1Min: ' ...
                    '</p>']);
                app.Input.Value = '0.000';
                app.Input.Visible = true;
                drawnow;
                
                while(~app.buttonOKPressed)
                    if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                        app.buttonOKPressed = 0;
                    end
                    drawnow;
                end
                app.buttonOKPressed = 0;
                Hmin = str2double(app.Input.Value);
                
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-align: justify; letter-spacing: 1px;">' ...
                    'Channel1Max: ' ...
                    '</p>']);
                app.Input.Value = '1.000';
                drawnow;
                
                while(~app.buttonOKPressed)
                    if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                        app.buttonOKPressed = 0;
                    end
                    drawnow;
                end
                app.buttonOKPressed = 0;
                Hmax = str2double(app.Input.Value);
                
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-align: justify; letter-spacing: 1px;">' ...
                    'Channel2Min: ' ...
                    '</p>']);
                app.Input.Value = '0.000';
                drawnow;
                
                while(~app.buttonOKPressed)
                    if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                        app.buttonOKPressed = 0;
                    end
                    drawnow;
                end
                app.buttonOKPressed = 0;
                Smin = str2double(app.Input.Value);
                
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-align: justify; letter-spacing: 1px;">' ...
                    'Channel2Max: ' ...
                    '</p>']);
                app.Input.Value = '1.000';
                drawnow;
                
                while(~app.buttonOKPressed)
                    if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                        app.buttonOKPressed = 0;
                    end
                    drawnow;
                end
                app.buttonOKPressed = 0;
                Smax = str2double(app.Input.Value);
                
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-align: justify; letter-spacing: 1px;">' ...
                    'Channel3Min: ' ...
                    '</p>']);
                app.Input.Value = '0.000';
                drawnow;
                
                while(~app.buttonOKPressed)
                    if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                        app.buttonOKPressed = 0;
                    end
                    drawnow;
                end
                app.buttonOKPressed = 0;
                Vmin = str2double(app.Input.Value);
                
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-align: justify; letter-spacing: 1px;">' ...
                    'Channel3Max: ' ...
                    '</p>']);
                app.Input.Value = '1.000';
                drawnow;
                
                while(~app.buttonOKPressed)
                    if(isempty(app.Input.Value) || ~isnumeric(app.Input.Value))
                        app.buttonOKPressed = 0;
                    end
                    drawnow;
                end
                app.buttonOKPressed = 0;
                Vmax = str2double(app.Input.Value);
                
                colorThresholder close;
                app.HSVColors.(cell2mat(app.colors(cor))) = struct('h', [Hmin Hmax],'s', [Smin Smax],'v', [Vmin Vmax]);
            end
            HSVColors = app.HSVColors;
            if ~(exist('.\.resources\Hue Saturation Value\HSV_Values.mat', 'file')==0)
                delete('.\.resources\Hue Saturation Value\HSV_Values.mat');
            end
            save('.\.resources\Hue Saturation Value\HSV_Values.mat',"HSVColors");
            
        end
        
        %% Função TestHSV (Etapa 0) >> Testar novas cores
        function TestHSV(app)
            
            app.buttonSIMPressed = 0;
            
            escolha = 'S';
            
            while(strcmpi(escolha,'S'))
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.ButtonOK.Visible = false;
                imgTeste = imread(app.IP_Webcam);
                app.Axe1.Visible = true;
                app.Axe1.Position = [63,71,300,185];
                if(size(imgTeste, 2) >= size(imgTeste, 1))
                    imshow(imresize(imgTeste, [size(imgTeste, 2) size(imgTeste, 2)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                else
                    imshow(imresize(imgTeste, [size(imgTeste, 1) size(imgTeste, 1)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                end
                app.HTMLText.Position = [102,53,436,246];
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                    'Pretende utilizar esta imagem?' ...
                    '</p>']);
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Position = [379,184,191,45];
                app.ButtonNAO.Position = [379,107,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed))
                    if (app.buttonNAOPressed )
                        app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                            'A aquirir nova imagem...' ...
                            '</p>']);
                        app.ButtonNAO.Enable = false;
                        app.ButtonSIM.Enable = false;
                        drawnow;
                        pause(1);
                        imgTeste = imread(app.IP_Webcam);
                        if(size(imgTeste, 2) >= size(imgTeste, 1))
                            imshow(imresize(imgTeste, [size(imgTeste, 2) size(imgTeste, 2)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                        else
                            imshow(imresize(imgTeste, [size(imgTeste, 1) size(imgTeste, 1)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                        end
                        app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                            'Pretende utilizar esta imagem?' ...
                            '</p>']);
                        app.ButtonNAO.Enable = true;
                        app.ButtonSIM.Enable = true;
                        app.buttonNAOPressed = 0;
                        drawnow;
                    end
                    drawnow;
                end
                app.buttonSIMPressed = 0;
                drawnow;
                
                Detected = {};
                for cor = 1:length(app.colors)
                    GetColor(app, cor);
                    FindColor(app, struct('Speed',0), struct('Speed',0));
                    if (~isempty(app.stats_cubo))
                        Detected(length(Detected)+1) = {cell2mat(app.colors(cor))};
                    end
                end
                
                Detected = unique(Detected);
                app.Info.Visible = false;
                app.Axe1.Position = [0,0,0,0];
                app.HTMLText.Position = [102,12,436,246];
                
                if (~isempty(Detected))
                    app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 2px;">' ...
                        '<p>Foram detetadas as seguintes cores: ']);
                    for corDetetada = 1:length(Detected)-1
                        app.HTMLText.HTMLSource = sprintf('%s <b style="color: %s">%s</b>, ',app.HTMLText.HTMLSource, cell2mat(Detected(corDetetada)), upper(cell2mat(Detected(corDetetada))));
                    end
                    app.HTMLText.HTMLSource = sprintf('%s <b style="color: %s">%s</b>.</p>',app.HTMLText.HTMLSource, cell2mat(Detected(length(Detected))), upper(cell2mat(Detected(length(Detected)))));
                    
                    app.HTMLText.HTMLSource = sprintf('%s <p style="text-align: center;">Quer testar novamente?</p>', app.HTMLText.HTMLSource);
                    app.Success.Visible = true;
                else
                    app.HTMLText.HTMLSource = sprintf(['<p style="text-indent: 5px; text-align: justify; letter-spacing: 2px;">' ...
                        '<p>Não foi detetada nenhuma cor.</p>' ...
                        '<p style="margin-top:20px; text-align: center;">Quer testar novamente?</p></p>']);
                    app.Warning.Visible = true;
                end
                
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Position = [336,98,191,45];
                app.ButtonSIM.Position = [121,98,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                end
                
                if (app.buttonSIMPressed )
                    escolha = 'S';
                    app.buttonSIMPressed = 0;
                    drawnow;
                end
                
                if (app.buttonNAOPressed )
                    escolha = 'N';
                    app.buttonNAOPressed = 0;
                    drawnow;
                end
                
            end
            
        end
        
        %% Função GetMotorWheight (Etapa 0) >> Obter peso de cada roda para calculo das equações
        function CheckMotorParams(app)
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            app.TitleHTMLInfo.Text = "[ Setup 4/5 ]  Calibração de Parametros";
            drawnow;
            
            if not(isfile('.\.resources\Motor Params\MotorParams.mat'))
                app.HTMLText.Position = [102,22,436,246];
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Indique no explorador onde se encontra o ficheiro "MotorParams.mat" para calibrar os motores.' ...
                    '</p>']);
                drawnow;
                [baseName, folder] = uigetfile({'*.mat', 'Motor Params File (*.mat)'}, 'Select the Precalibrated Motor Params file "MotorParams.mat"', 'MotorParams.mat');
                fullFileName = fullfile(folder, baseName);
            else
                baseName = 'MotorParams.mat';
                folder = '.\.resources\Motor Params\';
                fullFileName = fullfile(folder, baseName);
            end
            
            if(~isequal(baseName,0))
                load(fullFileName,"MotorWheightFW", "MotorWheightBW", "const_v", "slowConst_v", "Rotation_Idx");
                if ~(exist('.\.resources\Motor Params\MotorParams.mat', 'file')==0)
                    delete('.\.resources\Motor Params\MotorParams.mat');
                end
                save('.\.resources\Motor Params\MotorParams.mat',"MotorWheightFW", "MotorWheightBW", "const_v", "slowConst_v", "Rotation_Idx")
                app.MotorWheightFW = MotorWheightFW;
                app.MotorWheightBW = MotorWheightBW;
                app.const_v = const_v;
                app.slowConst_v = slowConst_v;
                app.Rotation_Idx = Rotation_Idx;
                
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'O ficheiro "MotorParams.mat" foi encontrado. Pretende mesmo assim calibrar os motores?' ...
                    '</p>']);
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Position = [336,118,191,45];
                app.ButtonSIM.Position = [121,118,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                end
                
                if (app.buttonSIMPressed)
                    GetMotorParams(app);
                    MotorWheightFW = app.MotorWheightFW;
                    MotorWheightBW = app.MotorWheightBW;
                    const_v = app.const_v;
                    slowConst_v = app.slowConst_v;
                    Rotation_Idx = app.Rotation_Idx;
                    if ~(exist('.\.resources\Motor Params\MotorParams.mat', 'file')==0)
                        delete('.\.resources\Motor Params\MotorParams.mat');
                    end
                    save('.\.resources\Motor Params\MotorParams.mat',"MotorWheightFW", "MotorWheightBW", "const_v", "slowConst_v", "Rotation_Idx");
                    app.buttonSIMPressed = 0;
                    drawnow;
                end
                app.buttonNAOPressed = 0;
            else
                GetMotorParams(app);
                MotorWheightFW = app.MotorWheightFW;
                MotorWheightBW = app.MotorWheightBW;
                const_v = app.const_v;
                slowConst_v = app.slowConst_v;
                Rotation_Idx = app.Rotation_Idx;
                if ~(exist('.\.resources\Motor Params\MotorParams.mat', 'file')==0)
                    delete('.\.resources\Motor Params\MotorParams.mat');
                end
                save('.\.resources\Motor Params\MotorParams.mat',"MotorWheightFW", "MotorWheightBW", "const_v", "slowConst_v", "Rotation_Idx");
            end
            
            
        end
        
        %% Função TrainMotorWheight (Etapa 0) >> Calibrar os motores
        function GetMotorParams(app)
            
            app.buttonSIMPressed = 0;
            app.left_motor.Speed = -0;
            app.right_motor.Speed = -0;
            app.ButtonOK.Visible = true;
            app.ButtonSIM.Visible = false;
            app.ButtonNAO.Visible = false;
            app.ButtonOK.Text = "OK";
            app.ButtonOK.Position = [217,95,191,45];
            app.HTMLText.Position = [93,21,454,258];
            app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                'Este procedimento vai verificar a força de ambos os motores. Clique em OK para prosseguir.' ...
                '</p>']);
            drawnow;
            
            while(~app.buttonOKPressed)
                drawnow;
            end
            app.buttonOKPressed = 0;
            
            app.slowConst_v = 0;
            app.MotorWheightFW = 0;
            MotorWheight_FW_OK = 0;
            MotorWheight_BW_OK = 0;
            Rotation_Idx_OK = 0;
            aux = 999;
            start = 0;
            
            for cor = 1:length(app.colors)
                GetColor(app, cor);
                FindColor(app, struct('Speed',0), struct('Speed',0));
                if (~isempty(app.stats_cubo))
                    break;
                end
            end
            
            app.HTMLText.Position = [37,31,565,258];
            app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Determinando a força dos motores para a frente...</p>']);
            app.ButtonOK.Visible = false;
            drawnow;
            
            while(~MotorWheight_FW_OK)
                
                
                FindColor(app, struct('Speed',0), struct('Speed',0));
                
                if(~isempty(app.stats_cubo))
                    Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*app.A_max);
                    
                    if ((Desv > -(app.A_max*0.04)) && (Desv < (app.A_max*0.04)) && (app.slowConst_v == 0))
                        app.left_motor.Speed = -10;
                        app.right_motor.Speed = 10;
                        pause(0.001);
                        app.left_motor.Speed = 0;
                        app.right_motor.Speed = 0;
                        continue
                    end
                    
                    if(floor(aux) == floor(Desv))
                        app.slowConst_v = app.slowConst_v - 1.5;
                    end
                    
                    motor_esq = app.slowConst_v;
                    motor_dir = app.slowConst_v;
                    
                    if (app.MotorWheightFW < 0)
                        motor_dir = round(motor_dir-(motor_dir*(-app.MotorWheightFW/100.00)));
                    elseif (app.MotorWheightFW > 0)
                        motor_esq = round(motor_esq-(motor_esq*(app.MotorWheightFW/100.00)));
                    end
                    
                    if ((Desv < -(app.A_max*0.04)) || (Desv > (app.A_max*0.04)))
                        if (Desv < 0)
                            app.left_motor.Speed = motor_esq;
                            app.right_motor.Speed = -motor_dir;
                            pause(0.001);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        elseif (Desv > 0)
                            app.left_motor.Speed = -motor_esq;
                            app.right_motor.Speed = motor_dir;
                            pause(0.001);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        end
                    else
                        app.left_motor.Speed = -motor_esq;
                        app.right_motor.Speed = -motor_dir;
                        pause(2);
                        app.left_motor.Speed = 0;
                        app.right_motor.Speed = 0;
                        
                        FindColor(app, struct('Speed',0), struct('Speed',0));
                        if(~isempty(app.stats_cubo))
                            Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*app.A_max);
                            
                            if ((Desv > -(app.A_max*0.04)) && (Desv < (app.A_max*0.04)))
                                MotorWheight_FW_OK = 1;
                            elseif floor(Desv) < 0
                                app.MotorWheightFW = app.MotorWheightFW - floor(Desv/2);
                                app.left_motor.Speed = (motor_esq);
                                app.right_motor.Speed = (motor_dir);
                                pause(2);
                                app.left_motor.Speed = 0;
                                app.right_motor.Speed = 0;
                            elseif floor(Desv) > 0
                                app.MotorWheightFW = app.MotorWheightFW - floor(Desv/2);
                                app.left_motor.Speed = (motor_esq);
                                app.right_motor.Speed = (motor_dir);
                                pause(2);
                                app.left_motor.Speed = 0;
                                app.right_motor.Speed = 0;
                            end
                        else
                            app.slowConst_v = app.slowConst_v - 1.5;
                            app.MotorWheightFW = 0;
                            app.left_motor.Speed = motor_esq;
                            app.right_motor.Speed = motor_dir;
                            pause(2);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        end
                    end
                    aux = Desv;
                else
                    app.left_motor.Speed = -35;
                    app.right_motor.Speed = 35;
                    pause(0.0001);
                    app.left_motor.Speed = (0);
                    app.right_motor.Speed = (0);
                end
            end
            
            app.HTMLText.HTMLSource = sprintf('%s <p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">', app.HTMLText.HTMLSource);
            if (app.MotorWheightFW < 0)
                app.HTMLText.HTMLSource = sprintf('%s O motor da direita tem %d%% mais força do que o motor da esquerda. </p>', app.HTMLText.HTMLSource, (app.MotorWheightFW*-1));
            elseif (app.MotorWheightFW > 0)
                app.HTMLText.HTMLSource = sprintf('%s O motor da esquerda tem %d%% mais força do que o motor da direita. </p>', app.HTMLText.HTMLSource, (app.MotorWheightFW*-1));
            else
                app.left_motor.Speed = -motor_esq;
                app.right_motor.Speed = -motor_dir;
                pause(2);
                app.left_motor.Speed = 0;
                app.right_motor.Speed = 0;
                app.HTMLText.HTMLSource = sprintf('%s Ambos os motores têm a mesma força. </p>', app.HTMLText.HTMLSource);
                app.MotorWheightFW = 1;
            end
            
            app.MotorWheightBW = app.MotorWheightFW;
            close all;
            
            app.HTMLText.HTMLSource = sprintf(['%s <p></p><p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Determinando a força dos motores para trás...</p>'], app.HTMLText.HTMLSource);
            
            while(~MotorWheight_BW_OK)
                
                
                FindColor(app, struct('Speed',0), struct('Speed',0));
                
                if(~isempty(app.stats_cubo))
                    Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*app.A_max);
                    
                    if ((Desv > -(app.A_max*0.04)) && (Desv < (app.A_max*0.04)) && (app.slowConst_v == 0))
                        app.left_motor.Speed = -30;
                        app.right_motor.Speed = 30;
                        pause(0.001);
                        app.left_motor.Speed = 0;
                        app.right_motor.Speed = 0;
                        continue
                    end
                    
                    if(floor(aux) == floor(Desv))
                        app.slowConst_v = app.slowConst_v - 1.5;
                    end
                    
                    motor_esq = app.slowConst_v;
                    motor_dir = app.slowConst_v;
                    
                    if (app.MotorWheightBW < 0)
                        motor_dir = round(motor_dir-(motor_dir*(-app.MotorWheightBW/100.00)));
                    elseif (app.MotorWheightBW > 0)
                        motor_esq = round(motor_esq-(motor_esq*(app.MotorWheightBW/100.00)));
                    end
                    
                    if ((Desv < -(app.A_max*0.04)) || (Desv > (app.A_max*0.04)))
                        if (Desv < 0)
                            app.left_motor.Speed = motor_esq;
                            app.right_motor.Speed = -motor_dir;
                            pause(0.001);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        elseif (Desv > 0)
                            app.left_motor.Speed = -motor_esq;
                            app.right_motor.Speed = motor_dir;
                            pause(0.001);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        end
                    else
                        app.left_motor.Speed = motor_esq;
                        app.right_motor.Speed = motor_dir;
                        pause(2);
                        app.left_motor.Speed = 0;
                        app.right_motor.Speed = 0;
                        
                        FindColor(app, struct('Speed',0), struct('Speed',0));
                        if(~isempty(app.stats_cubo))
                            Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*app.A_max);
                            
                            if ((Desv > -(app.A_max*0.04)) && (Desv < (app.A_max*0.04)))
                                MotorWheight_BW_OK = 1;
                            elseif floor(Desv) < 0
                                app.MotorWheightBW = app.MotorWheightBW + floor(Desv/2);
                                app.left_motor.Speed = -(motor_esq);
                                app.right_motor.Speed = -(motor_dir);
                                pause(2);
                                app.left_motor.Speed = 0;
                                app.right_motor.Speed = 0;
                            elseif floor(Desv) > 0
                                app.MotorWheightBW = app.MotorWheightBW + floor(Desv/2);
                                app.left_motor.Speed = -(motor_esq);
                                app.right_motor.Speed = -(motor_dir);
                                pause(2);
                                app.left_motor.Speed = 0;
                                app.right_motor.Speed = 0;
                            end
                        else
                            app.MotorWheightBW = 0;
                            app.left_motor.Speed = -(motor_esq);
                            app.right_motor.Speed = -(motor_dir);
                            pause(2);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        end
                    end
                    aux = Desv;
                else
                    app.left_motor.Speed = -motor_esq;
                    app.right_motor.Speed = motor_dir;
                    pause(0.0001);
                    app.left_motor.Speed = (0);
                    app.right_motor.Speed = (0);
                end
                
            end
            
            app.HTMLText.HTMLSource = sprintf('%s <p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">', app.HTMLText.HTMLSource);
            if (app.MotorWheightBW < 0)
                app.HTMLText.HTMLSource = sprintf('%s O motor da direita tem %d%% mais força do que o motor da esquerda. </p>', app.HTMLText.HTMLSource, (app.MotorWheightBW*-1));
            elseif (app.MotorWheightBW > 0)
                app.HTMLText.HTMLSource = sprintf('%s O motor da esquerda tem %d%% mais força do que o motor da direita. </p>', app.HTMLText.HTMLSource, (app.MotorWheightBW*-1));
            else
                app.left_motor.Speed = motor_esq;
                app.right_motor.Speed = motor_dir;
                pause(2);
                app.left_motor.Speed = 0;
                app.right_motor.Speed = 0;
                app.HTMLText.HTMLSource = sprintf('%s Ambos os motores têm a mesma força.</p>', app.HTMLText.HTMLSource);
                app.MotorWheightBW = 1;
            end
            
            app.HTMLText.HTMLSource = sprintf(['%s <p></p><p style="text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Determinando a velocidade de rotação...</p>'], app.HTMLText.HTMLSource);
            
            while(~Rotation_Idx_OK)
                
                FindColor(app, struct('Speed',0), struct('Speed',0));
                
                if(~isempty(app.stats_cubo))
                    Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*app.A_max);
                    
                    motor_esq = app.slowConst_v;
                    motor_dir = app.slowConst_v;
                    
                    if (app.MotorWheightFW < 0)
                        motor_dir = round(motor_dir-(motor_dir*(-app.MotorWheightFW/100.00)));
                    elseif (app.MotorWheightFW > 0)
                        motor_esq = round(motor_esq-(motor_esq*(app.MotorWheightFW/100.00)));
                    end
                    
                    if ((Desv < -(app.A_max*0.04)) || (Desv > (app.A_max*0.04)))
                        if (Desv < 0)
                            app.left_motor.Speed = motor_esq;
                            app.right_motor.Speed = -motor_dir;
                            pause(0.001);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        elseif (Desv > 0)
                            app.left_motor.Speed = -motor_esq;
                            app.right_motor.Speed = motor_dir;
                            pause(0.001);
                            app.left_motor.Speed = 0;
                            app.right_motor.Speed = 0;
                        end
                    else
                        seconds_past = 0;
                        step = 1;
                        while(~Rotation_Idx_OK)
                            switch step
                                case 1
                                    app.left_motor.Speed = -motor_esq*1.5;
                                    app.right_motor.Speed = motor_dir*1.5;
                                    pause(0.3);
                                    app.left_motor.Speed = 0;
                                    app.right_motor.Speed = 0;
                                    seconds_past = seconds_past + 0.3;
                                    FindColor(app, struct('Speed',0), struct('Speed',0));
                                    if(isempty(app.stats_cubo))
                                        step = 2;
                                    end
                                case 2
                                    app.left_motor.Speed = -motor_esq*1.5;
                                    app.right_motor.Speed = motor_dir*1.5;
                                    pause(0.3);
                                    app.left_motor.Speed = 0;
                                    app.right_motor.Speed = 0;
                                    seconds_past = seconds_past + 0.3;
                                    FindColor(app, struct('Speed',0), struct('Speed',0));
                                    if(~isempty(app.stats_cubo) &&...
                                            ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) >= 0.90) &&...
                                            ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) <= 1.35))
                                        Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*app.A_max);
                                        app.Rotation_Idx = (360-Desv)/seconds_past;
                                        Rotation_Idx_OK = 1;
                                    elseif(~isempty(app.stats_cubo))
                                        Desv = (((app.stats_cubo.BoundingBox(1))-(app.Midx))/app.Midx*app.A_max);
                                        app.Rotation_Idx = (360-Desv)/seconds_past;
                                        Rotation_Idx_OK = 1;
                                    end
                            end
                        end
                    end
                else
                    app.left_motor.Speed = -motor_esq;
                    app.right_motor.Speed = motor_dir;
                    pause(0.0001);
                    app.left_motor.Speed = (0);
                    app.right_motor.Speed = (0);
                end
                
            end
            
            app.Info.Visible=false;
            app.Success.Visible = true;
            app.HTMLText.HTMLSource = sprintf(['%s <p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'O robô completou uma volta em %.2f segundos.</p>'], app.HTMLText.HTMLSource, 360.00/app.Rotation_Idx);
            pause(2);
            app.HTMLText.HTMLSource = '<p style="; text-indent: 5px; text-align: center; letter-spacing: 1px;"></p>';
            app.Info.Visible=true;
            app.Success.Visible = false;
            app.HTMLText.Position = [93,21,454,258];
            
            if ((app.slowConst_v*4) > 100.00)
                app.const_v = 100; % Constante de velocidade das rodas
            else
                app.const_v = app.slowConst_v*4; % Constante de velocidade das rodas
            end
            
        end
        
        %% Função GetNN (Etapa 0) >> Obtem diretorio da NN ou treina uma nova
        function Get_NN(app)
            
            app.ButtonSIM.Enable = false;
            app.ButtonNAO.Enable = false;
            drawnow;
            app.ButtonSIM.Enable = true;
            app.ButtonNAO.Enable = true;
            app.TitleHTMLInfo.Text = "[ Setup 5/5 ]  NN para Identificar Formas";
            
            if not(isfile('.\.resources\Neural Network\Ev3Shapes.mat'))
                app.ButtonSIM.Visible = false;
                app.ButtonNAO.Visible = false;
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Indique no explorador onde se encontra o ficheiro "Ev3Shapes.mat" para carregar a rede neuronal.' ...
                    '</p>']);
                drawnow;
                [baseName, folder] = uigetfile({'*.mat', 'Neural Netword File (*.mat)'}, 'Select the Pre-Trained Neural Network "Ev3Shapes.mat"', 'Ev3Shapes.mat');
                fullFileName = fullfile(folder, baseName);
            else
                baseName = 'Ev3Shapes.mat';
                folder = '.\.resources\Neural Network\';
                fullFileName = fullfile(folder, baseName);
            end
            
            if(~isequal(baseName,0))
                app.nnet = coder.loadDeepLearningNetwork(fullFileName);
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'O ficheiro "Ev3Shapes.mat" foi encontrado. Pretende mesmo assim criar uma nova rede neuronal?' ...
                    '</p>']);
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Position = [336,118,191,45];
                app.ButtonSIM.Position = [121,118,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                end
                
                if (app.buttonSIMPressed)
                    if ~(exist('.\.resources\Neural Network\Training', 'file')==0)
                        rmdir('.\.resources\Neural Network\Training', 's');
                        mkdir('.\.resources\Neural Network\Training');
                    end
                    Train_NN(app);
                    nnet = app.nnet;
                    if ~(exist('.\.resources\Neural Network\Ev3Shapes.mat', 'file')==0)
                        delete('.\.resources\Neural Network\Ev3Shapes.mat');
                    end
                    save('.\.resources\Neural Network\Ev3Shapes.mat',"nnet");
                    app.buttonSIMPressed = 0;
                    drawnow;
                end
                app.buttonNAOPressed = 0;
                
            else
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.ButtonOK.Text = "OK";
                app.ButtonOK.Visible = true;
                app.ButtonOK.Position = [224,117,191,45];
                app.HTMLText.HTMLSource = sprintf(['<p style="; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'O ficheiro "Ev3Shapes.mat" não existe, pelo que será necessário criar uma nova rede neuronal.' ...
                    '</p>']);
                drawnow;
                
                while(~app.buttonOKPressed)
                    drawnow;
                end
                app.buttonOKPressed = 0;
                
                if ~(exist('.\.resources\Neural Network\Training', 'file')==0)
                    rmdir('.\.resources\Neural Network\Training', 's');
                    mkdir('.\.resources\Neural Network\Training');
                end
                Train_NN(app);
                nnet = app.nnet;
                if ~(exist('.\.resources\Neural Network\Ev3Shapes.mat', 'file')==0)
                    delete('.\.resources\Neural Network\Ev3Shapes.mat');
                end
                save('.\.resources\Neural Network\Ev3Shapes.mat',"nnet");
            end
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            app.ButtonSIM.Visible = true;
            app.ButtonNAO.Visible = true;
            app.HTMLText.Position = [102,32,436,246];
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-indent: 0px; text-align: justify; letter-spacing: 1px;">' ...
                'Quer testar a rede neuronal?' ...
                '</p>']);
            app.Input.Visible = false;
            app.ButtonOK.Visible = false;
            app.ButtonNAO.Visible = true;
            app.ButtonSIM.Text = "SIM";
            app.ButtonNAO.Text = "NAO";
            app.ButtonSIM.Visible = true;
            app.ButtonNAO.Position = [336,118,191,45];
            app.ButtonSIM.Position = [121,118,191,45];
            
            while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                drawnow;
            end
            
            if (app.buttonSIMPressed )
                Test_NN(app);
                app.buttonSIMPressed = 0;
                drawnow;
            end
            app.buttonNAOPressed = 0;
            
        end
        
        %% Função TrainNN (Etapa 0) >> Treina uma nova NN com base na aquisição de imagem
        function Train_NN(app)
            
            categories = zeros(0);
            app.HTMLText.HTMLSource = sprintf(['<p></p><p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Quantas amostras para cada caso pretende utilizar para treinar a NN? ' ...
                '</p>']);
            app.Input.Value = '50';
            app.Input.Visible = true;
            app.Input.Position = [121,118,191,45];
            app.ButtonOK.Visible = true;
            app.ButtonOK.Position = [336,118,191,45];
            app.ButtonNAO.Visible = false;
            app.ButtonSIM.Visible = false;
            app.buttonOKPressed = 0;
            
            while(~app.buttonOKPressed)
                drawnow;
                if(isempty(app.Input.Value))
                    app.buttonOKPressed = 0;
                end
            end
            
            amostras = str2double(app.Input.Value);
            app.buttonOKPressed = 0;
            app.ButtonOK.Visible = false;
            app.Input.Visible = true;
            
            app.Info.Visible = true;
            app.Success.Visible = false;
            
            app.buttonNAOPressed = 0;
            app.buttonSIMPressed = 0;
            while(~app.buttonNAOPressed)
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                    'Qual a forma que pretender treinar na rede neuronal? Caso não tenha mais formas para treinar clique em "Finalizar".' ...
                    '</p>']);
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.Input.Visible = true;
                app.Input.Value = 'Circulo';
                app.ButtonSIM.Text = "Guardar";
                app.ButtonNAO.Text = "Finalizar";
                app.ButtonNAO.Position = [227,60,191,45];
                app.ButtonSIM.Position = [336,118,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                    if(isempty(app.Input.Value))
                        app.buttonSIMPressed = 0;
                        app.buttonNAOPressed = 0;
                    end
                end
                
                if (app.buttonSIMPressed)
                    app.buttonSIMPressed = 0;
                    shape = app.Input.Value;
                end
                
                if (app.buttonNAOPressed)
                    app.buttonNAOPressed = 0;
                    break;
                end
                
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                    'Aponte a camara para o %s. Clique em "OK" para prosseguir.' ...
                    '</p>'], shape);
                app.ButtonNAO.Visible = false;
                app.ButtonSIM.Visible = false;
                app.Input.Visible = false;
                app.ButtonOK.Text = "OK";
                app.ButtonOK.Position = [224,117,191,45];
                app.ButtonNAO.Position = [336,118,191,45];
                app.ButtonSIM.Position = [121,118,191,45];
                app.ButtonOK.Visible = true;
                
                while(~app.buttonOKPressed)
                    drawnow;
                end
                app.buttonOKPressed = 0;
                
                app.ButtonOK.Visible = false;
                app.Input.Visible = false;
                app.ButtonNAO.Visible = false;
                app.ButtonSIM.Visible = false;
                if (~isfolder(sprintf('.\\.resources\\Neural Network\\Training\\%s', shape)))
                    mkdir(sprintf('.\\.resources\\Neural Network\\Training\\%s', shape));
                else
                    rmdir(sprintf('.\\.resources\\Neural Network\\Training\\%s', shape),'s');
                    mkdir(sprintf('.\\.resources\\Neural Network\\Training\\%s', shape));
                end
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                    'A tirar %.0f amostras de %ss em 3 segundos...' ...
                    '</p>'], amostras, shape);
                drawnow;
                pause(1);
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                    'A tirar %.0f amostras de %ss em 2 segundos...' ...
                    '</p>'], amostras, shape);
                drawnow;
                pause(1);
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                    'A tirar %.0f amostras de %ss em 1 segundos...' ...
                    '</p>'], amostras, shape);
                drawnow;
                pause(1);
                for cor = 1:length(app.colors)
                    GetColor(app, cor);
                    FindColor(app, struct('Speed',0), struct('Speed',0));
                    if (~isempty(app.stats_cubo))
                        break;
                    end
                end
                app.Axe1.Position = [196,52,247,177];
                cla(app.Axe1);
                for i = 0:amostras-1
                    FindColor(app, struct('Speed',0), struct('Speed',0));
                    while((app.forma_obj.NumObjects ~= 1) ||...
                            ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) < 1.00) ||...
                            ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) > 1.50) ||...
                            ((nnz(app.im_crop_SHAPE(:,1)) + ...
                            nnz(app.im_crop_SHAPE(:,size(app.im_crop_SHAPE,2))) + ...
                            nnz(app.im_crop_SHAPE(1,:)) + ...
                            nnz(app.im_crop_SHAPE(size(app.im_crop_SHAPE,1),:)))~=0))
                        FindColor(app, struct('Speed',0), struct('Speed',0));
                    end
                    imshow(imresize(255 * repmat(uint8(app.im_crop_SHAPE), 1, 1, 3), [227 227]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                    imwrite(imresize(255 * repmat(uint8(app.im_crop_SHAPE), 1, 1, 3), [227 227]),fullfile(sprintf('.\\.resources\\Neural Network\\Training\\%s\\', shape), sprintf('%s_%d.jpg', shape, (i+1))));
                    app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                        '%s gravado com sucesso!' ...
                        '</p>'], fullfile(sprintf('...\\%s\\', shape), sprintf('%s_%d.jpg', shape, (i+1))));
                    playTone(app.myev3, 1000, 0.3, app.vol_Ev3);
                end
                pause(1);
                app.Axe1.Position = [0,0,0,0];
                playTone(app.myev3, 500, 0.5, app.vol_Ev3);
                drawnow;
                if (isempty(categories))
                    categories = {sprintf('%s', shape)};
                else
                    categories(length(categories)+1) = {sprintf('%s', shape)};
                end
            end
            app.buttonNAOPressed = 0;
            
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Agora será necessário treinar a rede neuronal para detetar outros casos possiveis.' ...
                'Aponte a camara para as varias faces do cubo que não contenham a forma. Clique em "OK" para prosseguir.' ...
                '</p>']);
            app.ButtonOK.Visible = true;
            app.Input.Visible = false;
            app.ButtonSIM.Visible = false;
            app.ButtonNAO.Visible = false;
            
            while(~app.buttonOKPressed)
                drawnow;
            end
            app.ButtonOK.Visible = false;
            app.buttonOKPressed = 0;
            app.ButtonNAO.Visible = false;
            app.ButtonSIM.Visible = false;
            if (~isfolder('.\.resources\Neural Network\Training\None'))
                mkdir('.\.resources\Neural Network\Training\None');
            else
                rmdir('.\.resources\Neural Network\Training\None','s');
                mkdir('.\.resources\Neural Network\Training\None');
            end
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'A tirar %.0f amostras de outros resultados em 3 segundos...' ...
                '</p>'], amostras);
            drawnow;
            pause(1);
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'A tirar %.0f amostras de outros resultados em 2 segundos...' ...
                '</p>'], amostras);
            drawnow;
            pause(1);
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'A tirar %.0f amostras de outros resultados em 1 segundos...' ...
                '</p>'], amostras);
            drawnow;
            pause(1);
            for cor = 1:length(app.colors)
                GetColor(app, cor);
                FindColor(app, struct('Speed',0), struct('Speed',0));
                if (~isempty(app.stats_cubo))
                    break;
                end
            end
            app.Axe1.Position = [196,52,247,177];
            cla(app.Axe1);
            for i = 0:amostras-1
                FindColor(app, struct('Speed',0), struct('Speed',0));
                while((app.forma_obj.NumObjects == 0) ||...
                        ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) < 1.00) ||...
                        ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) > 1.50))
                    FindColor(app, struct('Speed',0), struct('Speed',0));
                end
                imshow(imresize(255 * repmat(uint8(app.im_crop_SHAPE), 1, 1, 3), [227 227]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                imwrite(imresize(255 * repmat(uint8(app.im_crop_SHAPE), 1, 1, 3), [227 227]),fullfile('.\.resources\Neural Network\Training\None\', sprintf('None_%d.jpg', (i+1))));
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                    '%s gravado com sucesso!' ...
                    '</p>'], fullfile('...\None\', sprintf('None_%d.jpg', (i+1))));
                playTone(app.myev3, 1000, 0.3, app.vol_Ev3);
            end
            categories(length(categories)+1) = {'None'};
            pause(1);
            app.Axe1.Position = [0,0,0,0];
            playTone(app.myev3, 500, 0.5, app.vol_Ev3);
            app.buttonSIMPressed = 0;
            drawnow;
            app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                'Treinando a rede neuronal "Ev3Shapes.mat" com os dados fornecidos...' ...
                '</p>'], app.Input.Value);
            drawnow;
            
            if not(isfile('.\.resources\Neural Network\AlexNet_params.mat'))
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: left; text-indent: 5px; text-align: justify; letter-spacing: 1px;">' ...
                    'Indique no explorador onde se encontra o ficheiro "AlexNet_params.mat" para carregar os parametros da rede neuronal.' ...
                    '</p>']);
                drawnow;
                [baseName, folder] = uigetfile({'*.mat', 'Parameters (*.mat)'}, ...
                    'Select the parameters from NN AlexNet "AlexNet_params.mat"', 'AlexNet_params.mat');
                fullFileName = fullfile(folder, baseName);
            else
                baseName = 'AlexNet_params.mat';
                folder = '.\.resources\Neural Network\';
                fullFileName = fullfile(folder, baseName);
            end
            
            if(~isequal(baseName,0))
                params = load(fullFileName);
            else
                clc; fprintf('\nO algoritmo não pode prosseguir sem o ficheiro "AlexNet_params.mat" que contém o peso das ligações entre neuronios já treinados.');
                app.nnet = zeros(0);
            end
            
            layers = [
                imageInputLayer([227 227 3],"Name","data","Mean",params.data.Mean)
                convolution2dLayer([11 11],96,"Name","conv1","BiasLearnRateFactor",2,"Stride",[4 4],"Bias",params.conv1.Bias,"Weights",params.conv1.Weights)
                reluLayer("Name","relu1")
                crossChannelNormalizationLayer(5,"Name","norm1","K",1)
                maxPooling2dLayer([3 3],"Name","pool1","Stride",[2 2])
                groupedConvolution2dLayer([5 5],128,2,"Name","conv2","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",params.conv2.Bias,"Weights",params.conv2.Weights)
                reluLayer("Name","relu2")
                crossChannelNormalizationLayer(5,"Name","norm2","K",1)
                maxPooling2dLayer([3 3],"Name","pool2","Stride",[2 2])
                convolution2dLayer([3 3],384,"Name","conv3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",params.conv3.Bias,"Weights",params.conv3.Weights)
                reluLayer("Name","relu3")
                groupedConvolution2dLayer([3 3],192,2,"Name","conv4","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",params.conv4.Bias,"Weights",params.conv4.Weights)
                reluLayer("Name","relu4")
                groupedConvolution2dLayer([3 3],128,2,"Name","conv5","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",params.conv5.Bias,"Weights",params.conv5.Weights)
                reluLayer("Name","relu5")
                maxPooling2dLayer([3 3],"Name","pool5","Stride",[2 2])
                fullyConnectedLayer(4096,"Name","fc6","BiasLearnRateFactor",2,"Bias",params.fc6.Bias,"Weights",params.fc6.Weights)
                reluLayer("Name","relu6")
                dropoutLayer(0.5,"Name","drop6")
                fullyConnectedLayer(4096,"Name","fc7","BiasLearnRateFactor",2,"Bias",params.fc7.Bias,"Weights",params.fc7.Weights)
                reluLayer("Name","relu7")
                dropoutLayer(0.5,"Name","drop7")
                fullyConnectedLayer(64, 'Name', 'special_add')
                reluLayer("Name","relu8_add")
                fullyConnectedLayer(length(categories), 'Name', 'fc8_new')
                softmaxLayer("Name","prob")
                classificationLayer("Name","output")]
            
            rootFolder = '.\.resources\Neural Network\Training\';
            imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames')
            
            opts = trainingOptions('sgdm', ...
                'LearnRateSchedule', 'None',...
                'InitialLearnRate', .0001,...
                'MaxEpochs', 20, ...
                'MiniBatchSize', 128)
            
            app.nnet = trainNetwork(imds, layers, opts);
            
        end
        
        %% Função TestNN (Etapa 0) >> Testar a rede neuronal "Ev3Shapes"
        function Test_NN(app)
            
            app.buttonSIMPressed = 0;
            escolha = 'S';
            
            while(strcmpi(escolha,'S'))
                app.Info.Visible = true;
                app.Success.Visible = false;
                app.ButtonOK.Visible = false;
                imgTeste = imread(app.IP_Webcam);
                app.Axe1.Visible = true;
                app.Axe1.Position = [63,71,300,185];
                if(size(imgTeste, 2) >= size(imgTeste, 1))
                    imshow(imresize(imgTeste, [size(imgTeste, 2) size(imgTeste, 2)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                else
                    imshow(imresize(imgTeste, [size(imgTeste, 1) size(imgTeste, 1)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                end
                app.HTMLText.Position = [102,53,436,246];
                app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                    'Pretende utilizar esta imagem?' ...
                    '</p>']);
                app.ButtonSIM.Visible = true;
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Position = [379,184,191,45];
                app.ButtonNAO.Position = [379,107,191,45];
                drawnow;
                
                while(~(app.buttonSIMPressed))
                    if (app.buttonNAOPressed )
                        app.ButtonNAO.Enable = false;
                        app.ButtonSIM.Enable = false;
                        app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                            'A aquirir nova imagem...' ...
                            '</p>']);
                        drawnow;
                        pause(1);
                        imgTeste = imread(app.IP_Webcam);
                        if(size(imgTeste, 2) >= size(imgTeste, 1))
                            imshow(imresize(imgTeste, [size(imgTeste, 2) size(imgTeste, 2)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                        else
                            imshow(imresize(imgTeste, [size(imgTeste, 1) size(imgTeste, 1)]), 'parent', app.Axe1, 'XData', [0 1], 'YData', [0 1]);
                        end
                        app.HTMLText.HTMLSource = sprintf(['<p style="text-align-last: center; text-align: justify; letter-spacing: 1px;">' ...
                            'Pretende utilizar esta imagem?' ...
                            '</p>']);
                        app.ButtonNAO.Enable = true;
                        app.ButtonSIM.Enable = true;
                        app.buttonNAOPressed = 0;
                        drawnow;
                    end
                    drawnow;
                end
                app.ButtonNAO.Visible = false;
                app.ButtonSIM.Visible = false;
                app.buttonSIMPressed = 0;
                app.HTMLText.Visible = false;
                
                app.Info.Visible = false;
                app.Axe1.Position = [0,0,0,0];
                app.HTMLText.Position = [71,53,502,246];
                
                for cor = 1:length(app.colors)
                    GetColor(app, cor);
                    FindColor(app, struct('Speed',0), struct('Speed',0));
                    if (~isempty(app.stats_cubo))
                        if ((app.forma_obj.NumObjects == 0) ||...
                                ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) < 1.00) ||...
                                ((size(app.im_crop_RGB,1) / size(app.im_crop_RGB,2)) > 1.50))
                            app.stats_cubo = zeros(0);
                            break;
                        else
                            break;
                        end
                    end
                end
                if (isempty(app.stats_cubo))
                    app.HTMLText.HTMLSource = sprintf(['<p></p><p></p><p style="text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                        'Não foi detetada nenhum cubo.</p>']);
                    app.Warning.Visible = true;
                else
                    if (app.forma_obj.NumObjects > 1)
                        app.im_crop_SHAPE = bwareafilt(app.im_crop_SHAPE,1);
                    end
                    [Predict, conf] = classify(app.nnet, imresize(255 * repmat(uint8(app.im_crop_SHAPE), 1, 1, 3), [227 227]), 'MiniBatchSize', 64);
                    app.HTMLText.HTMLSource = sprintf(['<p style="margin-top:30px; text-indent: 5px; text-align: center; letter-spacing: 1px;">' ...
                        'Resultado da previsão >> %s com uma confiança de %.2f%%</p>'], upper(Predict), ((max(conf))*100.00));
                end
                
                app.HTMLText.HTMLSource = sprintf(['%s ' ...
                    '<p></p><p style="margin-top:20px; text-align: center;">Quer testar novamente?</p>'], app.HTMLText.HTMLSource);
                app.ButtonNAO.Position = [336,98,191,45];
                app.ButtonSIM.Position = [121,98,191,45];
                app.ButtonNAO.Visible = true;
                app.ButtonSIM.Visible = true;
                app.HTMLText.Visible = true;
                drawnow;
                
                while(~(app.buttonSIMPressed || app.buttonNAOPressed))
                    drawnow;
                end
                
                if (app.buttonSIMPressed )
                    escolha = 'S';
                    app.buttonSIMPressed = 0;
                    drawnow;
                end
                
                if (app.buttonNAOPressed )
                    escolha = 'N';
                    app.buttonNAOPressed = 0;
                    drawnow;
                end
                
            end
            
        end
        
        %% Função CheckEnd (Etapa 1) >> Verifica se o circuito terminou
        function CheckEnd(app)
            if ((app.currentColor > length(app.colors)) || (app.colors(app.currentColor) == "End"))
                if (app.Realocating)
                    app.Realocating = 0;
                    app.etapa = 'None';
                    for cor = 1:6
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#000000";
                        app.(char(sprintf('Cor%d', cor))).Tag = "";
                        app.(char(sprintf('Cor%d', cor))).Value = "NONE";
                    end
                    
                    A_max = str2double(app.A_maxtxt.Value);
                    D_max = str2double(app.D_maxtxt.Value);
                    if ~(exist('.\.resources\Imaq Params\Imaq.mat', 'file')==0)
                        delete('.\.resources\Imaq Params\Imaq.mat');
                    end
                    save('.\.resources\Imaq Params\Imaq.mat',"A_max", "D_max");
                    HSVColors = app.HSVColors;
                    if ~(exist('.\.resources\Hue Saturation Value\HSV_Values.mat', 'file')==0)
                        delete('.\.resources\Hue Saturation Value\HSV_Values.mat');
                    end
                    save('.\.resources\Hue Saturation Value\HSV_Values.mat',"HSVColors");
                    MotorWheightFW = str2double(app.MotorWheightFWtxt.Value);
                    MotorWheightBW = str2double(app.MotorWheightBWtxt.Value);
                    if (str2double(app.slowconst_vtxt.Value)*4 > 100)
                        const_v = app.const_v;
                    else
                        const_v = str2double(app.slowconst_vtxt.Value)*4;
                    end
                    slowConst_v = str2double(app.slowconst_vtxt.Value);
                    Rotation_Idx = str2double(app.RotationidxLabel.Text);
                    if ~(exist('.\.resources\Motor Params\MotorParams.mat', 'file')==0)
                        delete('.\.resources\Motor Params\MotorParams.mat');
                    end
                    save('.\.resources\Motor Params\MotorParams.mat',"MotorWheightFW", "MotorWheightBW", "const_v", "slowConst_v", "Rotation_Idx");
                    nnet = app.nnet;
                    if ~(exist('.\.resources\Neural Network\Ev3Shapes.mat', 'file')==0)
                        delete('.\.resources\Neural Network\Ev3Shapes.mat');
                    end
                    save('.\.resources\Neural Network\Ev3Shapes.mat',"nnet");
                else
                    app.Realocating = 1;
                    app.currentColor = 2;
                    app.colorsbckp = app.colors;
                    app.colors = "Start";
                    for n = 1:numel(fieldnames(app.matchObjects))
                        if ~(length(app.matchObjects.(subsref(fieldnames(app.matchObjects),substruct('{}',{n})))) == 1)
                            for i = 1:(length(app.matchObjects.(subsref(fieldnames(app.matchObjects),substruct('{}',{n}))))-1)
                                app.colors(length(app.colors)+1) = app.matchObjects.(subsref(fieldnames(app.matchObjects),substruct('{}',{n})))(i+1);
                                app.colors(length(app.colors)+1) = "grabOn";
                                app.colors(length(app.colors)+1) = app.matchObjects.(subsref(fieldnames(app.matchObjects),substruct('{}',{n})))(i);
                                app.colors(length(app.colors)+1) = "grabOff";
                            end
                        end
                    end
                    app.colors(length(app.colors)+1) = "End";
                end
            else
                if ~((app.currentColor+1) > length(app.colors))
                    if (app.colors(app.currentColor + 1) == "grabOn")
                        app.GrabOn = 1;
                    else
                        app.GrabOn = 0;
                    end
                    if (app.colors(app.currentColor + 1) == "grabOff")
                        app.GrabOff = 1;
                    else
                        app.GrabOff = 0;
                    end
                else
                    app.GrabOn = 0;
                    app.GrabOff = 0;
                end
                
                app.etapatxt.Value = "GetColor";
                app.etapa = 'GetColor';
            end
        end
        
        %% Função GetColor (Etapa 2) >> Auxilia o percurso
        function GetColor(app, corAtual)
            
            app.h = app.HSVColors.(cell2mat(app.colors(corAtual))).h;
            app.s = app.HSVColors.(cell2mat(app.colors(corAtual))).s;
            app.v = app.HSVColors.(cell2mat(app.colors(corAtual))).v;
            
        end
        
        %% Função FindColor (Etapa 3) >> Plot da imagem da Camera e do recorte do obj de destino
        function FindColor(app, left_motor, right_motor)
            
            tic;
            
            if(ischar(app.IP_Webcam))
                im_RGB = imread(app.IP_Webcam);
            else
                im_RGB = app.IP_Webcam;
            end
            
            imshow(imresize(im_RGB, [size(im_RGB, 2) size(im_RGB, 2)]), 'parent', app.img1, 'XData', [0 1], 'YData', [0 1]);
            
            im_HSV = rgb2hsv(im_RGB);
            
            if app.h(1) < app.h(2)
                im_BIN=((im_HSV(:,:,1) >= app.h(1)) & (im_HSV(:,:,1) <= app.h(2))).*...
                    ((im_HSV(:,:,2) >= app.s(1)) & (im_HSV(:,:,2) <= app.s(2))).*...
                    ((im_HSV(:,:,3) >= app.v(1)) & (im_HSV(:,:,3) <= app.v(2)));
            else
                im_BIN=((im_HSV(:,:,1) >= app.h(1)) | (im_HSV(:,:,1) <= app.h(2))).*...
                    ((im_HSV(:,:,2) >= app.s(1)) & (im_HSV(:,:,2) <= app.s(2))).*...
                    ((im_HSV(:,:,3) >= app.v(1)) & (im_HSV(:,:,3) <= app.v(2)));
            end
            
            im_BW_no100 = bwareaopen(im_BIN, 1000);
            
            kernel_close = strel('disk', 3);
            im_BW_erode = imerode(im_BW_no100, kernel_close);
            im_BW_close = imdilate(im_BW_erode, kernel_close);
            
            kernel_open = strel('disk', 1);
            im_BW_close_dilate = imdilate(im_BW_close, kernel_open);
            im_BW_open = imerode(im_BW_close_dilate, kernel_open);
            
            im_BW_fill_holes = imfill(im_BW_open, 'holes');
            
            imshow(imresize(im_BW_fill_holes, [size(im_BW_fill_holes, 2) size(im_BW_fill_holes, 2)]), 'parent', app.img3, 'XData', [0 1], 'YData', [0 1]);
            
            cubo_obj = bwconncomp(im_BW_fill_holes,4);
            
            if cubo_obj.NumObjects > 0
                if cubo_obj.NumObjects > 1
                    im_BW_fill_holes = bwareafilt(im_BW_fill_holes,1);
                end
                
                app.stats_cubo = regionprops(im_BW_fill_holes, 'BoundingBox', 'Centroid');
                
                width = app.stats_cubo.BoundingBox(3);
                height = app.stats_cubo.BoundingBox(4);
                xLeft = app.stats_cubo.BoundingBox(1);
                yTop = app.stats_cubo.BoundingBox(2);
                
                app.im_crop_RGB = imcrop(im_RGB, [xLeft, yTop + 0.00 * height, width, height * 1.00]);
                app.im_crop_SHAPE = imcrop(~im_BW_close_dilate, [xLeft+(width/8), yTop+(height/8), 6*(width/8), 6*(height/8)]);
                
                app.forma_obj = bwconncomp(app.im_crop_SHAPE,8);
                
                imshow(imresize(app.im_crop_RGB, [size(app.im_crop_RGB, 2) size(app.im_crop_RGB, 2)]), 'parent', app.img2, 'XData', [0 1], 'YData', [0 1]);
                
                imshow(imresize(app.im_crop_SHAPE, [size(app.im_crop_SHAPE, 2) size(app.im_crop_SHAPE, 2)]), 'parent', app.img4, 'XData', [0 1], 'YData', [0 1]);
                
            else
                app.Circuito.Value = 2;
                app.stats_cubo = zeros(0);
                app.im_crop_SHAPE = 0;
                app.im_crop_RGB = 0;
                app.forma_obj = struct('NumObjects', 0);
                
                left_motor.Speed = (str2double(app.slowconst_vtxt.Value)*1.50);
                right_motor.Speed = -(str2double(app.slowconst_vtxt.Value)*1.50);
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                pause(0.05);
                left_motor.Speed = -(0);
                right_motor.Speed = (0);
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
            end
            
            app.FPS.Text = sprintf('%.1f FPS', (1.00/toc));
            
        end
        
        %% Função GoToColor (Etapa 4) >> Movimenta o robo
        function GoToColor(app)
            
            if (str2double(app.slowconst_vtxt.Value)*4 > 100)
                const_v = 100;
            else
                const_v = str2double(app.slowconst_vtxt.Value)*4;
            end
            
            Dist = ((app.yHeight-app.stats_cubo.Centroid(2))/app.yHeight *str2double(app.D_maxtxt.Value)*10);
            Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx *str2double(app.A_maxtxt.Value));
            
            range_norm = const_v*(0-str2double(app.A_maxtxt.Value))-const_v*(str2double(app.D_maxtxt.Value)*10-(-str2double(app.A_maxtxt.Value)));
            
            if ((Dist <= (str2double(app.D_maxtxt.Value)*10 * 0.45)) || ((app.GrabOff) && (Dist <= (str2double(app.D_maxtxt.Value)*10 * 0.7))))
                app.etapatxt.Value = "SetFinalPos";
                app.etapa = 'SetFinalPos';
                app.left_motor.Speed = - 0;
                app.right_motor.Speed = - 0;
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
            else
                app.etapatxt.Value = "GoToColor";
                app.etapa = 'GoToColor';
                motor_esq = const_v*(Dist+Desv);
                norm_esq = round(((motor_esq)/(range_norm))*-(const_v));
                motor_dir = const_v*(Dist-Desv);
                norm_dir = round(((motor_dir)/(range_norm))*-(const_v));
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -norm_esq, -norm_dir);
                if (str2double(app.MotorWheightFWtxt.Value) < 0)
                    norm_dir = round(norm_dir-(norm_dir*(-(str2double(app.MotorWheightFWtxt.Value)/100.00))));
                elseif (app.str2double(app.MotorWheightFWtxt.Value) > 0)
                    norm_esq = round(norm_esq-(norm_esq*(str2double(app.MotorWheightFWtxt.Value)/100.00)));
                end
                
                app.left_motor.Speed = -(norm_esq);
                app.right_motor.Speed = -(norm_dir);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
            end
        end
        
        %% Função SetFinalPos (Etapa 5) >> Posiciona o robo de forma a que seja possivel identificar e elevar a forma do objeto se necessário
        function SetFinalPos(app)
            
            Dist = ((app.yHeight-app.stats_cubo.Centroid(2))*str2double(app.D_maxtxt.Value)*10)/app.yHeight;
            Desv = (((app.stats_cubo.Centroid(1))-(app.Midx))/app.Midx*str2double(app.A_maxtxt.Value));
            
            motor_esq = str2double(app.slowconst_vtxt.Value);
            motor_dir = str2double(app.slowconst_vtxt.Value);
            
            if (str2double(app.MotorWheightFWtxt.Value) < 0)
                motor_dir = round(motor_dir-(motor_dir*(-(str2double(app.MotorWheightFWtxt.Value)/100.00))));
            elseif (str2double(app.MotorWheightFWtxt.Value) > 0)
                motor_esq = round(motor_esq-(motor_esq*(str2double(app.MotorWheightFWtxt.Value)/100.00)));
            end
            
            
            if (app.GrabOff)
                if (Desv > - (str2double(app.A_maxtxt.Value) * 0.8))
                    app.left_motor.Speed = - motor_esq;
                    app.right_motor.Speed = motor_dir;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -str2double(app.slowconst_vtxt.Value)*1.2, str2double(app.slowconst_vtxt.Value)*1.2);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    pause(0.001);
                    app.left_motor.Speed = 0;
                    app.right_motor.Speed = 0;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.etapatxt.Value = "SetFinalPos";
                    app.etapa = 'SetFinalPos';
                    
                else
                    app.left_motor.Speed = - motor_esq;
                    app.right_motor.Speed = - motor_dir;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -str2double(app.slowconst_vtxt.Value)*1.2, -str2double(app.slowconst_vtxt.Value)*1.2);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    pause(270.00/str2double(app.RotationidxLabel.Text));
                    app.left_motor.Speed = 0;
                    app.right_motor.Speed = 0;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    
                    while (readRotation(app.elev_motor) ~= app.garra_base) % Posição incial elevador
                        if (readRotation(app.elev_motor) > app.garra_base)
                            app.elev_motor.Speed = - (10);
                            pause(0.001)
                            app.elev_motor.Speed = 0;
                        else
                            app.elev_motor.Speed = (10);
                            pause(0.001)
                            app.elev_motor.Speed = 0;
                        end
                    end
                    
                    app.left_motor.Speed = motor_esq;
                    app.right_motor.Speed = motor_dir;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', str2double(app.slowconst_vtxt.Value)*1.2, str2double(app.slowconst_vtxt.Value)*1.2);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    pause(200.00/str2double(app.RotationidxLabel.Text));
                    app.left_motor.Speed = 0;
                    app.right_motor.Speed = 0;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.currentColor = app.currentColor + 2;
                    app.etapatxt.Value = "CheckEnd";
                    app.etapa = 'CheckEnd';
                end
                
            elseif (Dist > (str2double(app.D_maxtxt.Value)*10*0.45))
                app.etapatxt.Value = "GoToColor";
                app.etapa = 'GoToColor';
                app.left_motor.Speed = -0;
                app.right_motor.Speed = -0;
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                
            elseif ((Desv < -(str2double(app.A_maxtxt.Value)*0.04)) || (Desv > (str2double(app.A_maxtxt.Value)*0.04)))
                if (Desv < 0)
                    app.left_motor.Speed = motor_esq;
                    app.right_motor.Speed = -motor_dir;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', str2double(app.slowconst_vtxt.Value)*1.2, -str2double(app.slowconst_vtxt.Value)*1.2);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    pause(0.001);
                    app.left_motor.Speed = 0;
                    app.right_motor.Speed = 0;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    
                else
                    app.left_motor.Speed = -motor_esq;
                    app.right_motor.Speed = motor_dir;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -str2double(app.slowconst_vtxt.Value)*1.2, str2double(app.slowconst_vtxt.Value)*1.2);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    pause(0.001);
                    app.left_motor.Speed = 0;
                    app.right_motor.Speed = 0;
                    app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                    app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                end
                app.etapatxt.Value = "SetFinalPos";
                app.etapa = 'SetFinalPos';
                
            elseif (Dist > (str2double(app.D_maxtxt.Value)*10*0.067))
                
                app.left_motor.Speed = -motor_esq;
                app.right_motor.Speed = -motor_dir;
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -str2double(app.slowconst_vtxt.Value)*1.2, -str2double(app.slowconst_vtxt.Value)*1.2);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                pause(0.05);
                app.left_motor.Speed = 0;
                app.right_motor.Speed = 0;
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.etapatxt.Value = "SetFinalPos";
                app.etapa = 'SetFinalPos';
            else
                
                if (app.GrabOn)
                    app.elev_motor.Speed = -(20);
                    pause(0.8);
                else
                    app.elev_motor.Speed = -(20);
                    pause(0.1);
                    app.elev_motor.Speed = -(0);
                end
                
                if ~(app.GrabOn)
                    while (readRotation(app.elev_motor) ~= app.garra_base) % Posição incial elevador
                        if (readRotation(app.elev_motor) > app.garra_base)
                            app.elev_motor.Speed = - (10);
                            pause(0.001)
                            app.elev_motor.Speed = 0;
                        else
                            app.elev_motor.Speed = (10);
                            pause(0.001)
                            app.elev_motor.Speed = 0;
                        end
                    end
                end
                
                
                motor_esq = str2double(app.slowconst_vtxt.Value)*1.2;
                motor_dir = str2double(app.slowconst_vtxt.Value)*1.2;
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', motor_esq, motor_dir);
                
                if (str2double(app.MotorWheightBWtxt.Value) < 0)
                    motor_dir = round(motor_dir-(motor_dir*(-(str2double(app.MotorWheightBWtxt.Value)/100.00))));
                elseif (str2double(app.MotorWheightBWtxt.Value) > 0)
                    motor_esq = round(motor_esq-(motor_esq*(str2double(app.MotorWheightBWtxt.Value)/100.00)));
                end
                
                app.left_motor.Speed = (motor_esq);
                app.right_motor.Speed = (motor_dir);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                pause(200.00/str2double(app.RotationidxLabel.Text));
                app.left_motor.Speed = 0;
                app.right_motor.Speed = 0;
                app.Energytxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', app.left_motor.Speed, app.right_motor.Speed);
                
                if (app.GrabOn)
                    app.currentColor = app.currentColor + 2;
                    app.etapatxt.Value = "CheckEnd";
                    app.etapa = 'CheckEnd';
                else
                    app.etapatxt.Value = "GetShape";
                    app.etapa = 'GetShape';
                end
            end
            
        end
        
        %% Função GetShape (Etapa 6) >> Identifica forma no objeto ou volta á etapa anterior para considerar um reposicionamento
        function GetShape(app)
            
            if (app.forma_obj.NumObjects ~= 0)
                if (app.forma_obj.NumObjects > 1)
                    app.im_crop_SHAPE = bwareafilt(app.im_crop_SHAPE,1);
                end
                
                [Predict,conf] = classify(app.nnet, imresize(255 * repmat(uint8(app.im_crop_SHAPE), 1, 1, 3), [227 227]));
                app.DetectedShapetxt.Value = sprintf('%s', upper(Predict));
                app.Precisiontxt.Value = sprintf('%.1f%%', ((max(conf))*100.00));
                if (strcmpi(char(Predict),'none'))
                    Rotate(app);
                    
                    if (app.rotation_degrees == 360)
                        app.rotation_degrees = 0;
                    end
                    
                    app.etapatxt.Value = "FindColor";
                    app.etapa = 'FindColor';
                else
                    if ~(sum(strcmpi(fieldnames(app.matchObjects), char(Predict))))
                        app.matchObjects.(lower(char(Predict))) = sprintf("%s", char(app.colors(app.currentColor)));
                    else
                        app.matchObjects.(lower(char(Predict)))(length(app.matchObjects.(lower(char(Predict))))+1) = sprintf("%s", char(app.colors(app.currentColor)));
                    end
                    app.currentColor = app.currentColor + 1;
                    app.etapatxt.Value = "CheckEnd";
                    app.etapa = 'CheckEnd';
                end
            else
                Rotate(app);
                
                if (app.rotation_degrees == 360)
                    app.rotation_degrees = 0;
                end
                
                app.etapatxt.Value = "FindColor";
                app.etapa = 'FindColor';
            end
            
        end
        
        %% Função Rotate (Etapa auxiliar 6) >> Roda o robo em 90º graus
        function Rotate(app)
            
            const_v = str2double(app.slowconst_vtxt.Value);
            norm_dir = const_v;
            norm_esq = const_v;
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', const_v, const_v);
            
            if (str2double(app.MotorWheightFWtxt.Value) < 0)
                norm_dir = round(const_v-(const_v*(-(str2double(app.MotorWheightFWtxt.Value)/100.00))));
            elseif (str2double(app.MotorWheightFWtxt.Value) > 0)
                norm_esq = round(const_v-(const_v*(str2double(app.MotorWheightFWtxt.Value)/100.00)));
            end
            
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', norm_esq, norm_dir);
            
            app.left_motor.Speed = (norm_esq);
            app.right_motor.Speed = -(norm_dir);
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -const_v, const_v);
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', -norm_esq, norm_dir);
            pause(90.00/app.Rotation_Idx);
            app.left_motor.Speed = -(norm_esq);
            app.right_motor.Speed = -(norm_dir);
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -const_v, -const_v);
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', -norm_esq, -norm_dir);
            pause(360.00/app.Rotation_Idx);
            app.left_motor.Speed = -(norm_esq);
            app.right_motor.Speed = (norm_dir);
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', const_v, -const_v);
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', norm_esq, -norm_dir);
            pause(100.00/app.Rotation_Idx);
            app.left_motor.Speed = -(norm_esq);
            app.right_motor.Speed = -(norm_dir);
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', -const_v, -const_v);
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', -norm_esq, -norm_dir);
            pause(360.00/app.Rotation_Idx);
            app.left_motor.Speed = -(norm_esq);
            app.right_motor.Speed = (norm_dir);
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', const_v, -const_v);
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', norm_esq, -norm_dir);
            pause(150.00/app.Rotation_Idx);
            app.left_motor.Speed = 0;
            app.right_motor.Speed = 0;
            app.Energytxt.Value = sprintf('%.0f  ||  %.0f', 0, 0);
            app.Energyfinaltxt.Value = sprintf('%.0f  ||  %.0f', 0, 0);
            
            app.rotation_degrees = app.rotation_degrees + 90;
            
        end

    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            if(~isdeployed)
                cd(fileparts(which(mfilename)));
            end
            clc; clear; close all;
        end

        % Button pushed function: SETUPButton
        function SETUPButtonPushed(app, event)
            app.TabGroup.SelectedTab = app.TabGroup.Children(2);
            
            if (exist('app.myev3', 'var')) == 1
                clear('app.myev3');
                clear app.myev3;
                delete app.myev3;
            end
            
            if (exist('legoev3', 'var')) == 1
                clear('legoev3');
                clear legoev3;
                delete legoev3;
            end
            
            app.etapa = 'SettingUp';
            main(app);
        end

        % Button pushed function: CIRCUITOButton
        function CIRCUITOButtonPushed(app, event)
            
            app.TabGroup.SelectedTab = app.TabGroup.Children(3);
            
            app.currentColor = 1;
            backup = zeros(0);
            if ~(isempty(app.colorsbckp))
                for i =1:length(app.colorsbckp)
                    if~((strcmpi(app.colorsbckp(i),'end')) ||...
                            (strcmpi(app.colorsbckp(i),'start')) ||...
                            (strcmpi(app.colorsbckp(i),'GrafOn')) ||...
                            (strcmpi(app.colorsbckp(i),'GrabOff')))
                        if (isempty(backup))
                            backup = app.colorsbckp(i);
                        else
                            backup(length(backup)+1) = app.colorsbckp(i);
                        end
                    end
                end
            else
                for i =1:length(app.colors)
                    if~((strcmpi(app.colors(i),'end')) ||...
                            (strcmpi(app.colors(i),'start')) ||...
                            (strcmpi(app.colors(i),'GrafOn')) ||...
                            (strcmpi(app.colors(i),'GrabOff')))
                        if (isempty(backup))
                            backup = app.colors(i);
                        else
                            backup(length(backup)+1) = app.colors(i);
                        end
                    end
                end
            end
            backup = backup(randperm(length(backup)));
            
            for cor = 1:length(backup)
                switch true
                    case ((strcmpi(backup(cor),'red')) || (strcmpi(backup(cor),'vermelho')))
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#DE1717";
                        app.(char(sprintf('Cor%d', cor))).Tag = char(backup(cor));
                        app.(char(sprintf('Cor%d', cor))).Value = "";
                    case ((strcmpi(backup(cor),'green')) || (strcmpi(backup(cor),'verde')))
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#4F9F48";
                        app.(char(sprintf('Cor%d', cor))).Tag = char(backup(cor));
                        app.(char(sprintf('Cor%d', cor))).Value = "";
                    case ((strcmpi(backup(cor),'blue')) || (strcmpi(backup(cor),'azul')))
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#85F8FF";
                        app.(char(sprintf('Cor%d', cor))).Tag = char(backup(cor));
                        app.(char(sprintf('Cor%d', cor))).Value = "";
                    case ((strcmpi(backup(cor),'orange')) || (strcmpi(backup(cor),'laranja')))
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#FFAA5F";
                        app.(char(sprintf('Cor%d', cor))).Tag = char(backup(cor));
                        app.(char(sprintf('Cor%d', cor))).Value = "";
                    case ((strcmpi(backup(cor),'yellow')) || (strcmpi(backup(cor),'amarelo')))
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#FFF55F";
                        app.(char(sprintf('Cor%d', cor))).Tag = char(backup(cor));
                        app.(char(sprintf('Cor%d', cor))).Value = "";
                    case ((strcmpi(backup(cor),'purple')) || (strcmpi(backup(cor),'roxo')))
                        app.(char(sprintf('Cor%d', cor))).BackgroundColor = "#9E29FF";
                        app.(char(sprintf('Cor%d', cor))).Tag = char(backup(cor));
                        app.(char(sprintf('Cor%d', cor))).Value = "";
                end
            end
            app.colors = backup;
            
            app.MotorWheightFWtxt.Value = num2str(app.MotorWheightFW);
            app.MotorWheightBWtxt.Value = num2str(app.MotorWheightBW);
            app.slowconst_vtxt.Value = num2str(app.slowConst_v);
            app.A_maxtxt.Value = num2str(app.A_max);
            app.D_maxtxt.Value = num2str(app.D_max);
            app.RotationidxLabel.Text = num2str(floor(app.Rotation_Idx));
            app.Energytxt.Value = "0  ||  0";
            app.Energyfinaltxt.Value = "0  ||  0";
            app.DetectedShapetxt.Value = "NONE";
            app.Precisiontxt.Value = "NONE";
            
            app.img3.Position = [0,0,0,0];
            app.moldura3.Position = [0,0,0,0];
            app.img4.Position = [0,0,0,0];
            app.moldura4.Position = [0,0,0,0];
            app.FPS.Text = "";
            app.etapa = 'RotTest';
            app.etapatxt.Value = "RotTest";
        end

        % Button pushed function: ButtonOK
        function ButtonOKPushed(app, event)
            app.buttonOKPressed = 1;
        end

        % Button pushed function: ButtonNAO
        function ButtonNAOPushed(app, event)
            app.buttonNAOPressed = 1;
        end

        % Button pushed function: ButtonSIM
        function ButtonSIMPushed(app, event)
            app.buttonSIMPressed = 1;
        end

        % Button pushed function: ButtonGraphs
        function ButtonGraphsPushed(app, event)
            if (app.hidegraphs)
                app.img3.Position = [46,35,265,158];
                app.moldura3.Position = [34,5,284,205];
                app.img4.Position = [329,34,266,162];
                app.moldura4.Position = [320,5,285,205];
                app.hidegraphs = 0;
            else
                app.img3.Position = [0,0,0,0];
                app.moldura3.Position = [0,0,0,0];
                app.img4.Position = [0,0,0,0];
                app.moldura4.Position = [0,0,0,0];
                app.hidegraphs = 1;
            end
        end

        % Button pushed function: RotateTest
        function RotateTestButtonPushed(app, event)
            app.etapa = 'RotTest';
            app.etapatxt.Value = "RotTest";
            
            if (str2double(app.MotorWheightFWtxt.Value) < 0)
                app.right_motor.Speed = round(str2double(app.slowconst_vtxt.Value)*1.5-(str2double(app.slowconst_vtxt.Value)*1.5*(-(str2double(app.MotorWheightFWtxt.Value)/100.00))));
                app.left_motor.Speed = -(str2double(app.slowconst_vtxt.Value)*1.5);
            elseif (str2double(app.MotorWheightFWtxt.Value) > 0)
                app.right_motor.Speed = round(str2double(app.slowconst_vtxt.Value)*1.5-(str2double(app.slowconst_vtxt.Value)*1.5*(str2double(app.MotorWheightFWtxt.Value)/100.00)));
                app.left_motor.Speed = -(str2double(app.slowconst_vtxt.Value)*1.5);
            end
            
            pause(90.00/str2double(app.RotationidxLabel.Text));
            
            app.left_motor.Speed = 0;
            app.right_motor.Speed = 0;
        end

        % Button pushed function: RotateRight
        function RotateRightButtonPushed(app, event)
            app.RotationidxLabel.Text = num2str(str2double(app.RotationidxLabel.Text)-1.00);
        end

        % Button pushed function: RotateLeft
        function RotateLeftButtonPushed(app, event)
            app.RotationidxLabel.Text = num2str(str2double(app.RotationidxLabel.Text)+1.00);
        end

        % Button pushed function: RotationidxSave
        function RotationidxSaveButtonPushed(app, event)
            app.buttonOKPressed = 1;
            app.etapatxt.Value = "CheckEnd";
            app.etapa = 'CheckEnd';
        end

        % Button pushed function: ButtonOK_Error
        function ButtonOK_ErrorPushed(app, event)
            app.buttonOKPressed = 1;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 505];

            % Create InicioTab
            app.InicioTab = uitab(app.TabGroup);
            app.InicioTab.Title = 'Inicio';

            % Create HTML_2
            app.HTML_2 = uihtml(app.InicioTab);
            app.HTML_2.HTMLSource = '<div style="    border: 1px solid #ccc!important;position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"><p style="margin-left:20px; margin-right:20px; margin-top: 50px; font-family:arial; text-align: justify; text-justify: inter-word;"> Este procedimento tem como objetivo configurar todo o equipamento necessário para o circuito em si. O equipamente deve ser calibrado sempre que for utilizado já que de certa forma as condições testadas mudam constantemente como podemos verificar com a tonalidade e brilho das cores ou até com o piso. Este procedimento consiste em cinco etapas de calibração.</p></div>';
            app.HTML_2.Position = [33 31 580 196];

            % Create CIRCUITOButton
            app.CIRCUITOButton = uibutton(app.InicioTab, 'push');
            app.CIRCUITOButton.ButtonPushedFcn = createCallbackFcn(app, @CIRCUITOButtonPushed, true);
            app.CIRCUITOButton.IconAlignment = 'center';
            app.CIRCUITOButton.BackgroundColor = [0 0.4471 0.7412];
            app.CIRCUITOButton.FontSize = 20;
            app.CIRCUITOButton.FontColor = [1 1 1];
            app.CIRCUITOButton.Enable = 'off';
            app.CIRCUITOButton.Position = [33 186 574 41];
            app.CIRCUITOButton.Text = 'CIRCUITO';

            % Create HTML_3
            app.HTML_3 = uihtml(app.InicioTab);
            app.HTML_3.HTMLSource = '<div style="    border: 1px solid #ccc!important;position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"><p style="margin-left:20px; margin-right:20px; margin-top: 50px; font-family:arial; text-align: justify; text-justify: inter-word;"> Este procedimento tem como objetivo configurar todo o equipamento necessário para o circuito em si. O equipamente deve ser calibrado sempre que for utilizado já que de certa forma as condições testadas mudam constantemente como podemos verificar com a tonalidade e brilho das cores ou até com o piso. Este procedimento consiste em cinco etapas de calibração.</p></div>';
            app.HTML_3.Position = [33 247 580 195];

            % Create SETUPButton
            app.SETUPButton = uibutton(app.InicioTab, 'push');
            app.SETUPButton.ButtonPushedFcn = createCallbackFcn(app, @SETUPButtonPushed, true);
            app.SETUPButton.IconAlignment = 'center';
            app.SETUPButton.BackgroundColor = [0 0.4471 0.7412];
            app.SETUPButton.FontSize = 20;
            app.SETUPButton.FontColor = [1 1 1];
            app.SETUPButton.Position = [33 401 574 41];
            app.SETUPButton.Text = 'SETUP';

            % Create SetupTab
            app.SetupTab = uitab(app.TabGroup);
            app.SetupTab.Title = 'Setup';

            % Create TitleHTML
            app.TitleHTML = uihtml(app.SetupTab);
            app.TitleHTML.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.TitleHTML.Position = [33 375 574 81];

            % Create TitleHTMLInfo
            app.TitleHTMLInfo = uilabel(app.SetupTab);
            app.TitleHTMLInfo.HorizontalAlignment = 'center';
            app.TitleHTMLInfo.FontSize = 25;
            app.TitleHTMLInfo.Position = [33 400 574 31];
            app.TitleHTMLInfo.Text = '[ Setup 1/5 ]  Aquisição de imagem';

            % Create DescInfo
            app.DescInfo = uihtml(app.SetupTab);
            app.DescInfo.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.DescInfo.Position = [33 8 578 341];

            % Create Warning
            app.Warning = uihtml(app.SetupTab);
            app.Warning.HTMLSource = '<div style="color:#555; font-family:Tahoma, Geneva, Arial, sans-serif; font-size:11px; padding:10px 36px; margin:10px; color:#fff; -moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;background:#feb742 url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABqklEQVR4XqWTvWsUURTFf+/tx7DmA5sUmyB+EGQDCkFRxCFosYWCFgELm2ApCBYW/gOCFpYSrUMsBIv4BwTSCSqaWgsTEDRV2EVBZWffvXIYwhZOEdgLhzmcc+7h3WKCuzPOhI+P80rDzE7WwmAHIHnzVIxxl4qJVaKbkYrBxvyVZQRxaYcq0EmehvePzp5YnD67hCAuzd0PUWB2JNQazzo377D7+auAuDR51QWjZWxYvD2e34DsJw+fbwviSJOnTHWBO5aGt6fa84szF67CzguCIYgjTZ4yuP9fYGqO2avO8j348hSKff4OkiAuDXnKKDsqGD1989jSLWJvA/58g+YUv34Xgrg0eSij7MEpsXx66k62O932wjT030NjAuotXj/YE8SlyUMZZbWj3ejmEFubp69fg711yCYha0GWcXftjCAuTZ4yKKsd7dbNfHXuUk6jeAPNCSBCAJpGb78PiGel7gCmLHMXc76/21oNn57kfm5lFg0W0KBPDag7GoYBEuCUE0uy/fIH4cOjy27J0SlI56DEiSVFFi4dEUUIMRBrQZTzjDFj/87/ACmm3+QFX8sKAAAAAElFTkSuQmCC) no-repeat 10px 50%; border:1px solid #eda93b;"><span style="font-weight:bold; text-transform:uppercase; letter-spacing: 1px;">warning </span></div> ';
            app.Warning.Visible = 'off';
            app.Warning.Position = [24 298 591 62];

            % Create Info
            app.Info = uihtml(app.SetupTab);
            app.Info.HTMLSource = '<div style="color:#555; font-family:Tahoma, Geneva, Arial, sans-serif; font-size:11px; padding:10px 36px; margin:10px; color:#fff; -moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;background:#77d3e0 url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAwFBMVEX///8AVq0CYcADbNEDaMoDa88Das0EcdkFfe0CZMPv9fu/1esFe+kBXbkEdd8Uf+QEb9VRkdAGf/AFeecRacAEc9wBW7QBX7zs6dwFeudRjswGgvUFd+MCZscDbtTl4tIBWbFEo/rh3s7A2/QAVasCZcYEcNcBYL3n5NUFfOsWhe5UqPVCkNvj4NDd2swyhNMGgPIBXLbq59nB4Pw1m/lToOgCY8RBi9Lv9/8FduHm49QxfMfo5dcQYrNTnuVBhMhJU/nRAAAAAXRSTlMAQObYZgAAAMpJREFUeF4lzdVyRTEIQFGI57i7XXet+///VZN2vy0YBrA9HPZeF34v4L/XWXtVdRdIenT+/NheE2W8puxiJ7O2TZSq7jLiTMfm3u53YVXhIHriu3BIEuXVdYBI2Yr4Dex3npd22893KnpdFl9Qp2n3FgTbEZkm/oSQGuVSjiOagwJ9CPNcrodhPCEpb9MygycZDZTz0xyNsYhhkXMhGJuf0XhJXIBj1K/02YTGDQA4F042G7SRDwfs5EVo828qn3+sbW6cEZI1rsUvrDkTPAFMyQwAAAAASUVORK5CYII=) no-repeat 10px 50%; border:1px solid #6cc8d4;"><span style="font-weight:bold; text-transform:uppercase; letter-spacing: 1px;">notice </span></div>';
            app.Info.Position = [24 298 591 62];

            % Create Success
            app.Success = uihtml(app.SetupTab);
            app.Success.HTMLSource = '<div style="color:#555; font-family:Tahoma, Geneva, Arial, sans-serif; font-size:11px; padding:10px 36px; margin:10px; color:#fff; -moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;background:#4cbe83 url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAmJJREFUeNqkk0toE0Ech3+T3aRJX7RpPNgSgzQljYXiC1FbUcFrL9WTqAe96NGce+hF8KA5eVHsSaQni1CR4kHEFwoVxNrW0iJtA9lqk1TJbnZ2d3bGnbWPDT124Fvm9f32v+wMEUJgL02VD/IkASjEQw5IJwiGvd6AR3JzX8HjAwQmIEQRrjdyBcTV0v+AQBuKqpFcpiuTTiWS8eaG5qisz7D0I8vrK4MLxcWLlmPlvanJugq25NaGltFzfWezKpQYsxl0W99aa0x3dDcm25Mdb+fejVZNf94PCW1u6GwIRXJnegeyds2K6boOSmkdz3oeg5lO7GT6RDZCwjnp7AQwMdyzvztNdRozDAOmadZxt3vE3zZ1eNwLYbFUPJmWTjDgdKIpEa9Wq7Asy0dWsfZ7DTejV9BWbkKhUMC1l7cwOzcLTnlcOsGAAwqUqOu6+Hx+ClpZw8qvFaRIF061H4eqqhhbfooXpVdwQg6oTaPSCQaAuQw3Dl7GzMwMpg6N42iiHw/77/ny69J7PCiOATH4MJX5zk6AI1ZLxjod+XYHiqIgHA7jUe99hNUwFms/cXt5BLyZe/8CPjaxqHSCFXxcW9cqSlzB4I8h/61bXFq8DrRhW5bQaq0inWDAxJ/V8lIIxCRdBMe+X/DlvulBYF+9zLlrWpq5JJ2dAC6KrsHy5U/avGDcJCmCvq+enML2d0u4w0x9ujLPa25eOvUnkYtJpln4+1zLRbJN6UimMa6oalQuuRuM2gu1ij1vLHFH5NGqeKeQ7DrKfggvsS/0zcawx+7LpJAJtCjFoEL2ep3/CTAAj+gy+4Yc2yMAAAAASUVORK5CYII=) no-repeat 10px 50%; border:1px solid #36ad6f;"><span style="font-weight:bold; text-transform:uppercase; letter-spacing: 1px;">success </span></div>';
            app.Success.Visible = 'off';
            app.Success.Position = [24 298 591 62];

            % Create Error
            app.Error = uihtml(app.SetupTab);
            app.Error.HTMLSource = '<div style="color:#555; font-family:Tahoma, Geneva, Arial, sans-serif; font-size:11px; padding:10px 36px; margin:10px; color:#fff; -moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px; background:#e47c68 url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAC3UlEQVR4Xm2RX0iTXQDGn1c3N2uzbUwvwrpww9jcRW5qlvLdqNCHeKUGaxd+qFdeBUEiSYYYKJ9/SnCwm9puhjGD11ARTOFTIckMW15JGJVDy/xE9y7d9r7ndHZgMsQfPBfnvM/z8PIcnOW/7u6/t/4d9EcGh/27T0f9u89G/ZGhYf+XoSH/cnd3I84gIIMJt7vBeckQUtbWNFAIQCkoE0AAQYCmvFz+GI22zBqNQa/XyzOqdNhbU9Ngk+XQ8aSoobKM80js7KiKq6oCe5ubYATByAKj02ptKCUkRBYXNSeKgi9GIyjAleabyYRj9k1eWlJdTyQCj4uL7yJFk91+e9JecrJeUEDf5efT5UeP6PHREZ2rr6dhdk5pvq6OSvv7dHVkhK6y8wbTnM2WbHU47uC+zeZfY6YPZjN939hICSGUwUvesJL52loeTvOpre20uMdiEbPI4RFYBAoYi4vYCwTASpBz8SJuBYO4MT6OXIOB3/0/MQFlairl58qOxaCiiszDAsBX//rgAWRm1jc38w2gViMmSTiensb2vXsAIenn4yUqWZZBBAECtwvcsPr8OUoqK6HR6bhZjscRZneXFQUC86ZJUEB1QgHCw+AlEasVRQMDSL1GIhrl709Y8GpfHz53duLqxsZpSZwSZEmaHBCA68higbmnByeUIsrC6pUVqObnIUkx/E4mkf/wIQ4dDvDNUp7sbGRtm0yv17XaJAGQd3AAQyIBKSrBEA7jR1cXfvb24tLKW8TYYHmsxMg8CoDNCxfIlsEg8u2qTCZ3q14fKJIktdpshpENuOfzpQfjv2xub4c0M4N4JILvOh0JxGIdcbvdxws8Hg9+LSy4Pbm5gSuHh2qcD1/+h15PXsbjHerqat/LUAgCMvirsND9j1YbuJYqoZQPmMk2C79IJjtcHo/vSX8/zqXO6WoauFEp+ktLxSmXS5wtKxNfOZ2ir6JC9Ny82eIdG0MmfwCjX3/U2vu6zQAAAABJRU5ErkJggg==) no-repeat 10px 50%; border:1px solid #d46c57;"><span style="font-weight:bold; text-transform:uppercase; letter-spacing: 1px;">error: </span></div>';
            app.Error.Visible = 'off';
            app.Error.Position = [24 298 591 62];

            % Create HTMLText
            app.HTMLText = uihtml(app.SetupTab);
            app.HTMLText.HTMLSource = '{}';
            app.HTMLText.Position = [93 21 454 258];

            % Create Input
            app.Input = uieditfield(app.SetupTab, 'text');
            app.Input.HorizontalAlignment = 'center';
            app.Input.FontSize = 17;
            app.Input.Position = [121 118 191 45];
            app.Input.Value = '0.000';

            % Create ButtonOK
            app.ButtonOK = uibutton(app.SetupTab, 'push');
            app.ButtonOK.ButtonPushedFcn = createCallbackFcn(app, @ButtonOKPushed, true);
            app.ButtonOK.FontSize = 17;
            app.ButtonOK.FontWeight = 'bold';
            app.ButtonOK.Position = [336 118 191 45];
            app.ButtonOK.Text = 'OK';

            % Create Slider
            app.Slider = uislider(app.SetupTab);
            app.Slider.MajorTicks = [0 25 50 75 100];
            app.Slider.MinorTicks = [];
            app.Slider.Visible = 'off';
            app.Slider.Position = [108 162 194 3];

            % Create ButtonSIM
            app.ButtonSIM = uibutton(app.SetupTab, 'push');
            app.ButtonSIM.ButtonPushedFcn = createCallbackFcn(app, @ButtonSIMPushed, true);
            app.ButtonSIM.FontSize = 17;
            app.ButtonSIM.FontWeight = 'bold';
            app.ButtonSIM.Visible = 'off';
            app.ButtonSIM.Position = [336 118 191 45];
            app.ButtonSIM.Text = 'SIM';

            % Create ButtonNAO
            app.ButtonNAO = uibutton(app.SetupTab, 'push');
            app.ButtonNAO.ButtonPushedFcn = createCallbackFcn(app, @ButtonNAOPushed, true);
            app.ButtonNAO.FontSize = 17;
            app.ButtonNAO.FontWeight = 'bold';
            app.ButtonNAO.Visible = 'off';
            app.ButtonNAO.Position = [227 60 191 45];
            app.ButtonNAO.Text = 'NAO';

            % Create Axe1
            app.Axe1 = uiaxes(app.SetupTab);
            title(app.Axe1, '')
            xlabel(app.Axe1, '')
            ylabel(app.Axe1, '')
            app.Axe1.XTick = [0 1];
            app.Axe1.XTickLabel = '';
            app.Axe1.YTick = [0 1];
            app.Axe1.YTickLabel = '';
            app.Axe1.BackgroundColor = [1 1 1];
            app.Axe1.Position = [0 0 0 0];

            % Create CircuitoTab
            app.CircuitoTab = uitab(app.TabGroup);
            app.CircuitoTab.Title = 'Circuito';

            % Create moldura1
            app.moldura1 = uihtml(app.CircuitoTab);
            app.moldura1.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.moldura1.Position = [37 271 245 186];

            % Create moldura2
            app.moldura2 = uihtml(app.CircuitoTab);
            app.moldura2.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.moldura2.Position = [359 271 245 186];

            % Create img1
            app.img1 = uiaxes(app.CircuitoTab);
            title(app.img1, '')
            xlabel(app.img1, '')
            ylabel(app.img1, '')
            app.img1.XColor = [1 1 1];
            app.img1.XTick = [0 1];
            app.img1.XTickLabel = '';
            app.img1.YColor = [1 1 1];
            app.img1.YTick = [0 1];
            app.img1.YTickLabel = '';
            app.img1.ZColor = [1 1 1];
            app.img1.BackgroundColor = [1 1 1];
            app.img1.Position = [47 298 223 148];

            % Create img2
            app.img2 = uiaxes(app.CircuitoTab);
            title(app.img2, '')
            xlabel(app.img2, '')
            ylabel(app.img2, '')
            app.img2.XColor = [1 1 1];
            app.img2.XTick = [0 1];
            app.img2.XTickLabel = '';
            app.img2.YColor = [1 1 1];
            app.img2.YTick = [0 1];
            app.img2.YTickLabel = '';
            app.img2.ZColor = [1 1 1];
            app.img2.BackgroundColor = [1 1 1];
            app.img2.Position = [369 299 223 148];

            % Create moldura1_2
            app.moldura1_2 = uihtml(app.CircuitoTab);
            app.moldura1_2.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.moldura1_2.Position = [34 6 284 202];

            % Create ForaparaafrenteLabel
            app.ForaparaafrenteLabel = uilabel(app.CircuitoTab);
            app.ForaparaafrenteLabel.Position = [63 138 134 25];
            app.ForaparaafrenteLabel.Text = 'Força para a frente (%)';

            % Create MotorWheightFWtxt
            app.MotorWheightFWtxt = uieditfield(app.CircuitoTab, 'text');
            app.MotorWheightFWtxt.HorizontalAlignment = 'center';
            app.MotorWheightFWtxt.FontSize = 14;
            app.MotorWheightFWtxt.Position = [211 138 73 25];
            app.MotorWheightFWtxt.Value = '-30';

            % Create ForaparatrsLabel
            app.ForaparatrsLabel = uilabel(app.CircuitoTab);
            app.ForaparatrsLabel.Position = [63 114 134 25];
            app.ForaparatrsLabel.Text = 'Força para trás (%)';

            % Create MotorWheightBWtxt
            app.MotorWheightBWtxt = uieditfield(app.CircuitoTab, 'text');
            app.MotorWheightBWtxt.HorizontalAlignment = 'center';
            app.MotorWheightBWtxt.FontSize = 14;
            app.MotorWheightBWtxt.Position = [211 114 73 25];
            app.MotorWheightBWtxt.Value = '15';

            % Create VelocidademanobraskLabel
            app.VelocidademanobraskLabel = uilabel(app.CircuitoTab);
            app.VelocidademanobraskLabel.Position = [63 90 142 25];
            app.VelocidademanobraskLabel.Text = 'Velocidade manobras (k)';

            % Create slowconst_vtxt
            app.slowconst_vtxt = uieditfield(app.CircuitoTab, 'text');
            app.slowconst_vtxt.HorizontalAlignment = 'center';
            app.slowconst_vtxt.FontSize = 14;
            app.slowconst_vtxt.Position = [211 90 73 25];
            app.slowconst_vtxt.Value = '80';

            % Create parametros
            app.parametros = uilabel(app.CircuitoTab);
            app.parametros.BackgroundColor = [0 0.4471 0.7412];
            app.parametros.HorizontalAlignment = 'center';
            app.parametros.FontSize = 17;
            app.parametros.FontWeight = 'bold';
            app.parametros.FontColor = [1 1 1];
            app.parametros.Position = [34 179 284 31];
            app.parametros.Text = 'PARAMETROS';

            % Create moldura5
            app.moldura5 = uihtml(app.CircuitoTab);
            app.moldura5.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.moldura5.Position = [320 5 284 204];

            % Create informacao
            app.informacao = uilabel(app.CircuitoTab);
            app.informacao.BackgroundColor = [0 0.4471 0.7412];
            app.informacao.HorizontalAlignment = 'center';
            app.informacao.FontSize = 17;
            app.informacao.FontWeight = 'bold';
            app.informacao.FontColor = [1 1 1];
            app.informacao.Position = [321 179 284 31];
            app.informacao.Text = 'INFORMAÇÂO';

            % Create AmplitudemximaLabel
            app.AmplitudemximaLabel = uilabel(app.CircuitoTab);
            app.AmplitudemximaLabel.Position = [63 66 142 25];
            app.AmplitudemximaLabel.Text = 'Amplitude máxima (º)';

            % Create A_maxtxt
            app.A_maxtxt = uieditfield(app.CircuitoTab, 'text');
            app.A_maxtxt.HorizontalAlignment = 'center';
            app.A_maxtxt.FontSize = 14;
            app.A_maxtxt.Position = [211 66 73 25];
            app.A_maxtxt.Value = '55';

            % Create DistanciamximacmsLabel
            app.DistanciamximacmsLabel = uilabel(app.CircuitoTab);
            app.DistanciamximacmsLabel.Position = [63 42 142 25];
            app.DistanciamximacmsLabel.Text = 'Distancia máxima (cms)';

            % Create D_maxtxt
            app.D_maxtxt = uieditfield(app.CircuitoTab, 'text');
            app.D_maxtxt.HorizontalAlignment = 'center';
            app.D_maxtxt.FontSize = 14;
            app.D_maxtxt.Position = [211 42 73 25];
            app.D_maxtxt.Value = '100';

            % Create EtapaatualLabel
            app.EtapaatualLabel = uilabel(app.CircuitoTab);
            app.EtapaatualLabel.Position = [352 138 134 25];
            app.EtapaatualLabel.Text = 'Etapa atual';

            % Create etapatxt
            app.etapatxt = uieditfield(app.CircuitoTab, 'text');
            app.etapatxt.HorizontalAlignment = 'center';
            app.etapatxt.FontSize = 14;
            app.etapatxt.Position = [467 138 106 25];
            app.etapatxt.Value = 'SetFinalPos';

            % Create FormadetetadaLabel
            app.FormadetetadaLabel = uilabel(app.CircuitoTab);
            app.FormadetetadaLabel.Position = [352 66 134 25];
            app.FormadetetadaLabel.Text = 'Forma detetada';

            % Create DetectedShapetxt
            app.DetectedShapetxt = uieditfield(app.CircuitoTab, 'text');
            app.DetectedShapetxt.HorizontalAlignment = 'center';
            app.DetectedShapetxt.FontSize = 14;
            app.DetectedShapetxt.Position = [467 66 106 25];
            app.DetectedShapetxt.Value = 'Square';

            % Create PrecisoLabel
            app.PrecisoLabel = uilabel(app.CircuitoTab);
            app.PrecisoLabel.Position = [352 42 134 25];
            app.PrecisoLabel.Text = 'Precisão (%)';

            % Create Precisiontxt
            app.Precisiontxt = uieditfield(app.CircuitoTab, 'text');
            app.Precisiontxt.HorizontalAlignment = 'center';
            app.Precisiontxt.FontSize = 14;
            app.Precisiontxt.Position = [467 42 106 25];
            app.Precisiontxt.Value = '95%';

            % Create EqEnergiaLabel
            app.EqEnergiaLabel = uilabel(app.CircuitoTab);
            app.EqEnergiaLabel.Position = [352 114 134 25];
            app.EqEnergiaLabel.Text = 'Eq. Energia';

            % Create Energytxt
            app.Energytxt = uieditfield(app.CircuitoTab, 'text');
            app.Energytxt.HorizontalAlignment = 'center';
            app.Energytxt.FontSize = 14;
            app.Energytxt.Position = [467 114 106 25];
            app.Energytxt.Value = '53  ||  48';

            % Create EqEnergiaFinalLabel
            app.EqEnergiaFinalLabel = uilabel(app.CircuitoTab);
            app.EqEnergiaFinalLabel.Position = [352 90 134 25];
            app.EqEnergiaFinalLabel.Text = 'Eq. Energia Final';

            % Create Energyfinaltxt
            app.Energyfinaltxt = uieditfield(app.CircuitoTab, 'text');
            app.Energyfinaltxt.HorizontalAlignment = 'center';
            app.Energyfinaltxt.FontSize = 14;
            app.Energyfinaltxt.Position = [467 90 106 25];
            app.Energyfinaltxt.Value = '61  ||  54';

            % Create moldura3
            app.moldura3 = uihtml(app.CircuitoTab);
            app.moldura3.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.moldura3.Position = [0 0 0 0];

            % Create img3
            app.img3 = uiaxes(app.CircuitoTab);
            title(app.img3, '')
            xlabel(app.img3, '')
            ylabel(app.img3, '')
            app.img3.XColor = [1 1 1];
            app.img3.XTick = [0 1];
            app.img3.XTickLabel = '';
            app.img3.YColor = [1 1 1];
            app.img3.YTick = [0 1];
            app.img3.YTickLabel = '';
            app.img3.ZColor = [1 1 1];
            app.img3.BackgroundColor = [1 1 1];
            app.img3.Position = [0 0 0 0];

            % Create moldura4
            app.moldura4 = uihtml(app.CircuitoTab);
            app.moldura4.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.moldura4.Position = [0 0 0 0];

            % Create img4
            app.img4 = uiaxes(app.CircuitoTab);
            title(app.img4, '')
            xlabel(app.img4, '')
            ylabel(app.img4, '')
            app.img4.XColor = [1 1 1];
            app.img4.XTick = [0 1];
            app.img4.XTickLabel = '';
            app.img4.YColor = [1 1 1];
            app.img4.YTick = [0 1];
            app.img4.YTickLabel = '';
            app.img4.ZColor = [1 1 1];
            app.img4.BackgroundColor = [1 1 1];
            app.img4.Position = [0 0 0 0];

            % Create ButtonGraphs
            app.ButtonGraphs = uibutton(app.CircuitoTab, 'push');
            app.ButtonGraphs.ButtonPushedFcn = createCallbackFcn(app, @ButtonGraphsPushed, true);
            app.ButtonGraphs.IconAlignment = 'center';
            app.ButtonGraphs.BackgroundColor = [0.6784 0.8196 1];
            app.ButtonGraphs.FontSize = 15;
            app.ButtonGraphs.Position = [291 425 57 31];
            app.ButtonGraphs.Text = '📊👀';

            % Create NaCor
            app.NaCor = uieditfield(app.CircuitoTab, 'text');
            app.NaCor.HorizontalAlignment = 'center';
            app.NaCor.FontColor = [1 1 1];
            app.NaCor.BackgroundColor = [0.149 0.149 0.149];
            app.NaCor.Position = [78 223 57 22];
            app.NaCor.Value = 'NONE';

            % Create Cor1
            app.Cor1 = uieditfield(app.CircuitoTab, 'text');
            app.Cor1.HorizontalAlignment = 'center';
            app.Cor1.FontColor = [1 1 1];
            app.Cor1.BackgroundColor = [0.149 0.149 0.149];
            app.Cor1.Position = [148 223 57 22];
            app.Cor1.Value = 'NONE';

            % Create Cor2
            app.Cor2 = uieditfield(app.CircuitoTab, 'text');
            app.Cor2.HorizontalAlignment = 'center';
            app.Cor2.FontColor = [1 1 1];
            app.Cor2.BackgroundColor = [0.149 0.149 0.149];
            app.Cor2.Position = [221 223 57 22];
            app.Cor2.Value = 'NONE';

            % Create Cor3
            app.Cor3 = uieditfield(app.CircuitoTab, 'text');
            app.Cor3.HorizontalAlignment = 'center';
            app.Cor3.FontColor = [1 1 1];
            app.Cor3.BackgroundColor = [0.149 0.149 0.149];
            app.Cor3.Position = [292 223 57 22];
            app.Cor3.Value = 'NONE';

            % Create Cor4
            app.Cor4 = uieditfield(app.CircuitoTab, 'text');
            app.Cor4.HorizontalAlignment = 'center';
            app.Cor4.FontColor = [1 1 1];
            app.Cor4.BackgroundColor = [0.149 0.149 0.149];
            app.Cor4.Position = [362 223 57 22];
            app.Cor4.Value = 'NONE';

            % Create Cor5
            app.Cor5 = uieditfield(app.CircuitoTab, 'text');
            app.Cor5.HorizontalAlignment = 'center';
            app.Cor5.FontColor = [1 1 1];
            app.Cor5.BackgroundColor = [0.149 0.149 0.149];
            app.Cor5.Position = [435 223 57 22];
            app.Cor5.Value = 'NONE';

            % Create Cor6
            app.Cor6 = uieditfield(app.CircuitoTab, 'text');
            app.Cor6.HorizontalAlignment = 'center';
            app.Cor6.FontColor = [1 1 1];
            app.Cor6.BackgroundColor = [0.149 0.149 0.149];
            app.Cor6.Position = [506 223 57 22];
            app.Cor6.Value = 'NONE';

            % Create FPS
            app.FPS = uilabel(app.CircuitoTab);
            app.FPS.HorizontalAlignment = 'center';
            app.FPS.Position = [292 290 57 22];
            app.FPS.Text = '2.6 FPS';

            % Create RotationidxLabel
            app.RotationidxLabel = uilabel(app.CircuitoTab);
            app.RotationidxLabel.BackgroundColor = [1 1 1];
            app.RotationidxLabel.HorizontalAlignment = 'center';
            app.RotationidxLabel.FontColor = [0.149 0.149 0.149];
            app.RotationidxLabel.Visible = 'off';
            app.RotationidxLabel.Position = [291 374 57 22];
            app.RotationidxLabel.Text = '231';

            % Create RotateTest
            app.RotateTest = uibutton(app.CircuitoTab, 'push');
            app.RotateTest.ButtonPushedFcn = createCallbackFcn(app, @RotateTestButtonPushed, true);
            app.RotateTest.IconAlignment = 'center';
            app.RotateTest.BackgroundColor = [0.6784 0.8196 1];
            app.RotateTest.FontSize = 15;
            app.RotateTest.Position = [291 395 57 31];
            app.RotateTest.Text = '🔄90º';

            % Create RotateRight
            app.RotateRight = uibutton(app.CircuitoTab, 'push');
            app.RotateRight.ButtonPushedFcn = createCallbackFcn(app, @RotateRightButtonPushed, true);
            app.RotateRight.IconAlignment = 'center';
            app.RotateRight.BackgroundColor = [0.6784 0.8196 1];
            app.RotateRight.FontSize = 15;
            app.RotateRight.Visible = 'off';
            app.RotateRight.Position = [320 342 28 31];
            app.RotateRight.Text = '⏩';

            % Create RotateLeft
            app.RotateLeft = uibutton(app.CircuitoTab, 'push');
            app.RotateLeft.ButtonPushedFcn = createCallbackFcn(app, @RotateLeftButtonPushed, true);
            app.RotateLeft.IconAlignment = 'center';
            app.RotateLeft.BackgroundColor = [0.6784 0.8196 1];
            app.RotateLeft.FontSize = 15;
            app.RotateLeft.Visible = 'off';
            app.RotateLeft.Position = [292 342 28 31];
            app.RotateLeft.Text = '⏪';

            % Create RotationidxSave
            app.RotationidxSave = uibutton(app.CircuitoTab, 'push');
            app.RotationidxSave.ButtonPushedFcn = createCallbackFcn(app, @RotationidxSaveButtonPushed, true);
            app.RotationidxSave.IconAlignment = 'center';
            app.RotationidxSave.BackgroundColor = [0.6784 0.8196 1];
            app.RotationidxSave.FontSize = 14;
            app.RotationidxSave.Visible = 'off';
            app.RotationidxSave.Position = [292 318 56 25];
            app.RotationidxSave.Text = '✅';

            % Create Circuito
            app.Circuito = uislider(app.CircuitoTab);
            app.Circuito.Limits = [1 9];
            app.Circuito.MajorTicks = [2 3 4 5 6 7 8];
            app.Circuito.MajorTickLabels = {''};
            app.Circuito.MinorTicks = [];
            app.Circuito.Position = [34 260 571 3];
            app.Circuito.Value = 2;

            % Create ErrorTab
            app.ErrorTab = uitab(app.TabGroup);
            app.ErrorTab.Title = 'Error';

            % Create DescInfo_2
            app.DescInfo_2 = uihtml(app.ErrorTab);
            app.DescInfo_2.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.DescInfo_2.Position = [31 5 578 341];

            % Create Error_2
            app.Error_2 = uihtml(app.ErrorTab);
            app.Error_2.HTMLSource = '<div style="color:#555; font-family:Tahoma, Geneva, Arial, sans-serif; font-size:11px; padding:10px 36px; margin:10px; color:#fff; -moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px; background:#e47c68 url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAC3UlEQVR4Xm2RX0iTXQDGn1c3N2uzbUwvwrpww9jcRW5qlvLdqNCHeKUGaxd+qFdeBUEiSYYYKJ9/SnCwm9puhjGD11ARTOFTIckMW15JGJVDy/xE9y7d9r7ndHZgMsQfPBfnvM/z8PIcnOW/7u6/t/4d9EcGh/27T0f9u89G/ZGhYf+XoSH/cnd3I84gIIMJt7vBeckQUtbWNFAIQCkoE0AAQYCmvFz+GI22zBqNQa/XyzOqdNhbU9Ngk+XQ8aSoobKM80js7KiKq6oCe5ubYATByAKj02ptKCUkRBYXNSeKgi9GIyjAleabyYRj9k1eWlJdTyQCj4uL7yJFk91+e9JecrJeUEDf5efT5UeP6PHREZ2rr6dhdk5pvq6OSvv7dHVkhK6y8wbTnM2WbHU47uC+zeZfY6YPZjN939hICSGUwUvesJL52loeTvOpre20uMdiEbPI4RFYBAoYi4vYCwTASpBz8SJuBYO4MT6OXIOB3/0/MQFlairl58qOxaCiiszDAsBX//rgAWRm1jc38w2gViMmSTiensb2vXsAIenn4yUqWZZBBAECtwvcsPr8OUoqK6HR6bhZjscRZneXFQUC86ZJUEB1QgHCw+AlEasVRQMDSL1GIhrl709Y8GpfHz53duLqxsZpSZwSZEmaHBCA68higbmnByeUIsrC6pUVqObnIUkx/E4mkf/wIQ4dDvDNUp7sbGRtm0yv17XaJAGQd3AAQyIBKSrBEA7jR1cXfvb24tLKW8TYYHmsxMg8CoDNCxfIlsEg8u2qTCZ3q14fKJIktdpshpENuOfzpQfjv2xub4c0M4N4JILvOh0JxGIdcbvdxws8Hg9+LSy4Pbm5gSuHh2qcD1/+h15PXsbjHerqat/LUAgCMvirsND9j1YbuJYqoZQPmMk2C79IJjtcHo/vSX8/zqXO6WoauFEp+ktLxSmXS5wtKxNfOZ2ir6JC9Ny82eIdG0MmfwCjX3/U2vu6zQAAAABJRU5ErkJggg==) no-repeat 10px 50%; border:1px solid #d46c57;"><span style="font-weight:bold; text-transform:uppercase; letter-spacing: 1px;">error: </span></div>';
            app.Error_2.Position = [22 293 591 62];

            % Create TitleHTML_2
            app.TitleHTML_2 = uihtml(app.ErrorTab);
            app.TitleHTML_2.HTMLSource = '<div style="    border: 1px solid #ccc!important; position: absolute; height: 90%; background-color:white; border: 2px solid #00000012;border-radius: 10px;width: 98%;padding: 2px;box-shadow: 0px 0px 17px 0px rgb(0 0 0 / 15%);"></div>';
            app.TitleHTML_2.Position = [31 372 574 81];

            % Create TitleHTMLInfo_2
            app.TitleHTMLInfo_2 = uilabel(app.ErrorTab);
            app.TitleHTMLInfo_2.HorizontalAlignment = 'center';
            app.TitleHTMLInfo_2.FontSize = 25;
            app.TitleHTMLInfo_2.Position = [30 401 574 31];
            app.TitleHTMLInfo_2.Text = 'Ocorreu um erro durante o programa...';

            % Create HTMLText_Error
            app.HTMLText_Error = uihtml(app.ErrorTab);
            app.HTMLText_Error.HTMLSource = '{''<body><p>'';''dsadasdsada'';''</p>'';''</body>''}';
            app.HTMLText_Error.Position = [53 50 520 198];

            % Create ButtonOK_Error
            app.ButtonOK_Error = uibutton(app.ErrorTab, 'push');
            app.ButtonOK_Error.ButtonPushedFcn = createCallbackFcn(app, @ButtonOK_ErrorPushed, true);
            app.ButtonOK_Error.FontSize = 17;
            app.ButtonOK_Error.FontWeight = 'bold';
            app.ButtonOK_Error.Position = [228 74 191 45];
            app.ButtonOK_Error.Text = 'Voltar';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = a13954_a13958_UI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end