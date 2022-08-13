Mox.defmock(RexbugMock, for: Rexerbug.RexbugApi)
Application.put_env(:rexerbug, :rexbug, RexbugMock)
ExUnit.start()
