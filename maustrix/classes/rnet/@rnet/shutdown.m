function [r rx]=shutdown(r,rx,subjects)
constants=r.constants;

firstErr=[];

switch r.type
    case r.constants.nodeTypes.SERVER_TYPE
        r=stopAcceptingConnections(r);

        %doTimeHists(r);
        
        clients=listClients(r);
        %         try
        for i=1:length(clients)
            try
                [r rx]=remoteClientShutdown(r,clients(i),rx,subjects);
            catch ex
                firstErr=ex;
                disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
            end
            try
                cList=disconnectClient(r,clients(i));
                cList=[]; % Ignore leftover commands
            catch ex
                disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
            end
        end
        %         catch
        %             % Must ensure that server is shutdown properly
        %             if ~isempty(r)
        %                 r.server.shutdown();
        %                 r.server.shutdownAll();
        %             end
        %             % Now throw the error that occurred
        %
        %         end

        try
            r.server.shutdown();
            r.server.shutdownAll();

            while ~r.server.isShutdown
                if rand>.99
                    'waiting for ratrix server thread to shutdown'
                end
            end

            r.server=[];
        catch ex
            disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
            %rethrow(ex);
        end
        if ~isempty(firstErr)
            %rethrow(firstErr)
        end
        
        
    case r.constants.nodeTypes.CLIENT_TYPE
        r.client.shutdown();

        while ~r.client.isShutdown
            if rand>.99
                'waiting for ratrix client thread to shutdown'
            end
        end

        r.client=[];
    otherwise
        error('Unknown rnet type in shutdown');
end
fprintf('threads should be exited\n')
%struct(r)
clearTemporaryFiles(r);

r=[];