Mox.defmock(RexbugMock, for: Rexerbug.Api)
Application.put_env(:rexerbug, :rexbug, RexbugMock)
ExUnit.start()
