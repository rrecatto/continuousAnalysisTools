function gmail(address,subject,message)
if ~exist('address','var')
    error('gmail:variableRequired','address is missing');
end
if ~exist('subject','var')
    error('gmail:variableRequired','subject is missing');
end
if ~exist('message','var')
    warning('gmail:variablePreferred','message is missing.using default message');
    message = '';
end
% Define these variables appropriately:
mail = 'ghoshlab@gmail.com'; %Your GMail email address
password = 'visualcortex'; %Your GMail password

% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email
sendmail(address,subject,message)
end