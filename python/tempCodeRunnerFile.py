son_data[response.command] = response.value.magnitude
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        loop.run_until_complete(send_json_data())