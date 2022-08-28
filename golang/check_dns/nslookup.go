package main

import (
    "fmt"
    "net"
    "time"

    "github.com/slack-go/slack"
)

func main() {
    _, err := net.LookupTXT("도메인 이름")

    if err != nil {
        api := slack.New("xoxb-슬랙웹훅", slack.OptionDebug(true))

        attachment := slack.Attachment{
            Pretext: "Devops Bot Message",
            Text:    "test 의 도메인이 네임서버랑 분리 되었습니다. ",
            // Color Styles the Text, making it possible to have like Warnings etc.
            Color: "#36a64f",
            // Fields are Optional extra data!
            Fields: []slack.AttachmentField{
                {
                    Title: "thegiftingcompany.io",
                    Value: time.Now().String(),
                },
            },
        }

        channelID, timestamp, err := api.PostMessage(
            "C0142M9QAQ5",
            slack.MsgOptionText("도메인 등록 알림입니다.", false),
            slack.MsgOptionAttachments(attachment),
            slack.MsgOptionAsUser(true), // Add this if you want that the bot would post message as a user, otherwise it will send response using the default slackbot
        )
        if err != nil {
            fmt.Printf("%s\n", err)
            return
        }
        fmt.Printf("Message successfully sent to channel %s at %s", channelID, timestamp)
    }
}
