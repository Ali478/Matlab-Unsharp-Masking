classdef Assignment2_c_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        ApplyUnsharpMaskingButton  matlab.ui.control.Button
        UploadImageButton          matlab.ui.control.Button
        UIAxes2_3                  matlab.ui.control.UIAxes
        UIAxes2_2                  matlab.ui.control.UIAxes
        UIAxes2                    matlab.ui.control.UIAxes
        UIAxes                     matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadImageButton
        function UploadImageButtonPushed(app, event)
            global a;
            [filename, pathname] = uigetfile('*.*', 'Pick an Image');
            filename=strcat(pathname,filename);
            a = imread(filename); % Input image
            imshow(a,'Parent',app.UIAxes);
            a = im2double(a);
        end

        % Button pushed function: ApplyUnsharpMaskingButton
        function ApplyUnsharpMaskingButtonPushed(app, event)
            global a;
            [m,n] = size(a);  % size of input image
            D0 = 50; % Assigning Cut-off Frequency  
            A = fft2(a);   %fourier transform of input image

            A_shift = fftshift(A);  %shifting origin
            A_real = abs(A_shift);  %Real part of A_shift (Freq domain repres of image)

            H = zeros(m,n);
            D = zeros(m,n);
            for u=1:m
                for v=1:n
                    D(u,v)=sqrt((u-(m/2))^2+(v-(n/2))^2);
                    if D(u,v)<=D0
                        H(u,v) = 0;
                    else
                        H(u,v) = 1; 
                    end
                end
            end

            AHB = 2.0; %High boost factor(can be changed)
            H1 = (AHB-1)+ H;
            X = A_shift.*H; %Multiplication by HPF
            X1 = A_shift.*H1;%Multiplication by HBF
            XA = abs(ifft2(X));
            XB = abs(ifft2(X1));
            
            imshow(XA,'Parent',app.UIAxes2);
            imshow(XB,'Parent',app.UIAxes2_2);
            imshow(a+XA,'Parent',app.UIAxes2_3);
            
            subplot(2,2,2);
            imshow(XA);
            title('High pass image');
            
            subplot(2,2,3);
            imshow(XB);
            title('High boost image');
            
            subplot(2,2,4);
            imshow(a+XA);
            title('Input + High pass image');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 831 665];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Orignal Image')
            app.UIAxes.Position = [364 450 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'High Pass Image')
            app.UIAxes2.Position = [39 82 250 187];

            % Create UIAxes2_2
            app.UIAxes2_2 = uiaxes(app.UIFigure);
            title(app.UIAxes2_2, 'High Pass Image')
            app.UIAxes2_2.Position = [312 82 250 187];

            % Create UIAxes2_3
            app.UIAxes2_3 = uiaxes(app.UIFigure);
            title(app.UIAxes2_3, 'High Pass Image')
            app.UIAxes2_3.Position = [561 82 250 187];

            % Create UploadImageButton
            app.UploadImageButton = uibutton(app.UIFigure, 'push');
            app.UploadImageButton.ButtonPushedFcn = createCallbackFcn(app, @UploadImageButtonPushed, true);
            app.UploadImageButton.Position = [104 514 199 57];
            app.UploadImageButton.Text = 'Upload Image';

            % Create ApplyUnsharpMaskingButton
            app.ApplyUnsharpMaskingButton = uibutton(app.UIFigure, 'push');
            app.ApplyUnsharpMaskingButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyUnsharpMaskingButtonPushed, true);
            app.ApplyUnsharpMaskingButton.Position = [40 308 244 51];
            app.ApplyUnsharpMaskingButton.Text = 'Apply Unsharp Masking';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Assignment2_c_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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