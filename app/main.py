import flet as ft
from flet import Page, Row, TextField, ElevatedButton

def main(page: Page):
    page.title = "Flet counter example"

    txt_message = TextField(value="", text_align="left", hint_text="Please enter text here")

    def send_click(e):
        if not txt_message.value:
            txt_message.error_text = "Please enter message"
            page.update()
        else:
            message = txt_message.value
            page.add(ft.Text(f"Sended: {message}"))
            page.update()

    page.add(
        Row(
            [
                txt_message,
                ElevatedButton("Send", on_click=send_click)
            ],
            alignment="center",
        )
    )

ft.app(target=main, port=8080, view=ft.WEB_BROWSER)