# NotificationML
Notification solution


Detalhamento de Arquitetura 

1- Aplicativo mobile: o aplicativo mobile vai receber as notifications baseado nas preferencias
do usuario.

2- Sistema Backend: O back-end vai conter toda a logica de negocio, para enviar as notificações, Receber/Enviar preferencias do usuario, e também fazer o controlede opt-out requests.

3- Serviço de Notificação: serviço responsavel pela entrega de notificações para web, SMS e e-mail.


Serviços AWS que serão utilizados:

    1- Amazon API Gateway:
        Proposito: Expor um ponto de acesso Rest API, para o aplicativo mobile e outros serviços enviarem preferencias de usuario para o sistema back-and.

        motivo: providencia escalabilidade e segurança para gerenciamento de APIs;

    2- AWS Lambda 1: 
        proposito: receber e salvar em banco de dados os seguintes dados: preferencias de usuario, Endpoint registrado no Serviço SNS e status de opt-out.

        motivo: serviço serverless, escalavel e com um custo efetivo;

    3- AWS Lambda 2: 
        Proposito: recupera e gerencia preferencias de usuarios/endpoint/opt-out e envia para o serviço SQS;

        motivo: serviço serverless, escalavel e com um custo efetivo;

    4- AWS Lambda 3: 
        Proposito: Recupera mensagem do SQS e envia para o serviço SNS no endpoint recebido;
                   para mensagens que podem ser enviadas para todos dispositivos conectados no Topico, enviar sem endpoint;

        motivo: serviço serverless, escalavel e com um custo efetivo;

    5- Amazon SNS (Simple Notification Service):
        Proposito: Enviar notificações para aplicações, SMS e e-mail;

        motivo: SNS é um serviço de menssageria totalmente gerenciavel que suporta multiplos canais de notificações e altamente escalavel;

    6- Amazon DynamoDB:
        Proposito: Salvar preferencias de usuario e opt-out status;

        motivo: Serviço nao relacional, banco de dados que providencia baixa latencia e escalavel.

    7- SQS (Simple Queue Service):
        Proposito: enfileirar as notificações e garantir que serão processadas o quanto antes.

        motivo: SQS ajuda no desacoplamento e escalabilidade de microserviços, serviços distribuidos e aplicações serverless.

    8- Amazon CloudWatch:
        Proposito: monitorar a performance e saude dos serviços

        Motivo: cloudwatch providencia monitoramento e observabilidade para os recursos AWS.


Fluxo de Arquitetura:
    Desenho anexado no repositorio:
