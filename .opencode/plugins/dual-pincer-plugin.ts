import type { Plugin } from "@opencode-ai/plugin"

export default (async (input) => {
  const client = input.client

  return {
    tool: {
      dp_analyze: {
        description: "Submit a draft to two independent concurrent agents: Pincer A (steelman) proves it right, Pincer B (red team) proves it wrong. Returns both analyses for the mediator to reconcile.",
        args: {
          draft: {
            type: "string",
            description: "The draft plan or reasoning to analyze",
          },
        },
        async execute(
          args: { draft: string },
          context: { sessionID: string; directory: string },
        ) {
          const sessionA = await client.session.create({
            directory: context.directory,
          })
          const sessionB = await client.session.create({
            directory: context.directory,
          })

          const sessionsAId = (sessionA as any).data?.id ?? (sessionA as any).id
          const sessionsBId = (sessionB as any).data?.id ?? (sessionB as any).id

          const [resultA, resultB] = await Promise.all([
            client.session.prompt({
              sessionID: sessionsAId,
              agent: "dual-pincer-steelman",
              parts: [{ type: "text", text: args.draft }],
            }),
            client.session.prompt({
              sessionID: sessionsBId,
              agent: "dual-pincer-redteam",
              parts: [{ type: "text", text: args.draft }],
            }),
          ])

          const extractText = (r: any): string => {
            const parts = r.data?.parts ?? r.parts ?? []
            return parts
              .filter((p: any) => p.type === "text")
              .map((p: any) => p.text)
              .join("\n")
          }

          const defense = extractText(resultA)
          const attack = extractText(resultB)

          return JSON.stringify({ defense, attack })
        },
      },
    },
  }
})
