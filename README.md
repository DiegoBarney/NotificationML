# NotificationML
Notification solution

Detalhamento de Arquitetura 

1- Aplicativo mobile: o aplicativo mobile vai receber as notifications baseado nas preferencias
do usuario.

2- Sistema Backend: O back-end vai conter toda a logica de negocio, para enviar as notificações, receber preferencias do usuario, cadastrar FCM/APNS no servico SNS e também fazer o controle de opt-out requests.

3- Serviço de Notificação: serviço responsavel pela entrega de notificações para APNS/FCM, WEB, SMS e e-mail.


Serviços AWS que serão utilizados:

    1- Amazon API Gateway:
        Proposito: Expor um ponto de acesso Rest API, para o aplicativo mobile e outros serviços enviarem preferencias de usuario, token registrado (ex: FCM (Firebase cloud messaging) para android ou APNS (Apple Push Notification Service) para IOS) e status de opt-out para o sistema back-and.

        exemplo de payload:
            {
                "user":{
                    "registered-devices-tokens":[ "token-device-1-FCM-example-skaksdkas",
                                           "token-device-2-APNS-example-skaksdkas"
                    ],
                    "user-data": {
                        .......
                    },
                    "opt-out": "true"
                }
            }

        motivo: providencia escalabilidade e segurança para gerenciamento de APIs;

    2- AWS Lambda 1: 
        proposito: receber e salvar em banco de dados os seguintes dados do usuario: preferencias do usuario, Endpoint cadastrado pelo Tokens FCM/APNS no serviço SNS e status de opt-out.

        motivo: serviço serverless, escalavel e com um custo efetivo;

    3- AWS Lambda 2: 
        Proposito: recuperar e gerenciar preferencias de usuarios/ endpoints /opt-out e enviar para o serviço SQS caso opt-out = true;

        motivo: serviço serverless, escalavel e com um custo efetivo;

    4- AWS Lambda 3: 
        Proposito: Recuperar mensagem do serviço SQS e enviar para o serviço SNS no endpoint cadastrado pelo dispositivo em caso de mensagem individual ou enviar para o topico em caso de mensagem coletiva;

        motivo: serviço serverless, escalavel e com um custo efetivo;

    5- Amazon SNS (Simple Notification Service):
        Proposito: Enviar notificações para aplicações, SMS e e-mail;

        Criar Topico e Endpoint para cada dispositivo cadastrado

        motivo: SNS é um serviço de menssageria totalmente gerenciavel que suporta multiplos canais de notificações e altamente escalavel;

    6- Amazon DynamoDB:
        Proposito: Salvar preferencias de usuario, endpoints SNS e opt-out status;

        motivo: Serviço nao relacional, banco de dados que providencia baixa latencia e escalavel.

    7- SQS (Simple Queue Service):
        Proposito: enfileirar as notificações e garantir que serão processadas o quanto antes e que pode existir retentativas em caso de falha.

        motivo: SQS ajuda no desacoplamento e escalabilidade de microserviços, serviços distribuidos e aplicações serverless.

    8- Amazon CloudWatch:
        Proposito: monitorar a performance e saude dos serviços

        Motivo: cloudwatch providencia monitoramento e observabilidade para os recursos AWS.


Fluxo de Arquitetura:
    Desenho anexado no repositorio:
