require "./spec_helper"

describe FacebookBot::Bot do
  it "should process all messages" do
    json = <<-JSON
    {
      "object": "page",
      "entry": [
        {
          "id": "PAGE_ID",
          "time": 1458692752478,
          "messaging": [
            {
              "sender": {
                "id": "USER_ID"
              },
              "recipient": {
                "id": "PAGE_ID"
              },
              "timestamp": 1458692752478,
              "message": {
                "mid": "mid.1457764197618:41d102a3e1ae206a38",
                "text": "hello, world!",
                "quick_reply": {
                  "payload": "DEVELOPER_DEFINED_PAYLOAD"
                }
              }
            },
            {
              "sender": {
                "id": "USER_ID_2"
              },
              "recipient": {
                "id": "PAGE_ID"
              },
              "timestamp": 1458692752478,
              "message": {
                "mid": "mid.1457764197618:41d102a3e1ae206a39",
                "text": "hola, mundo!"
              }
            }
          ]
        },
        {
          "id": "PAGE_ID",
          "time": 1458692752480,
          "messaging": [
            {
              "sender": {
                "id": "USER_ID_3"
              },
              "recipient": {
                "id": "PAGE_ID"
              },
              "timestamp": 1458692752480,
              "message": {
                "mid": "mid.1457764197618:41d102a3e1ae206a3a",
                "text": "bye, world!"
              }
            },
            {
              "sender": {
                "id": "USER_ID_4"
              },
              "recipient": {
                "id": "PAGE_ID"
              },
              "delivery": {
                "mids": [
                  "mid.1458668856218:ed81099e15d3f4f233"
                ],
                "watermark": 1458668856253,
                "seq": 37
              }
            }
          ]
        }
      ]
    }
    JSON

    callback = FacebookBot::Incoming::Callback.from_json(json)
    callback.entries.size.should eq(2)

    entry = callback.entries[0]
    entry.id.should eq("PAGE_ID")
    entry.time.should eq(1458692752478)
    entry.messaging.size.should eq(2)

    messages = callback.messaging(FacebookBot::Incoming::Message).to_a
    messages.size.should eq(3)
    messages.map(&.sender.id).should eq(["USER_ID", "USER_ID_2", "USER_ID_3"])
    messages.map(&.text).should eq(["hello, world!", "hola, mundo!", "bye, world!"])
  end
end
