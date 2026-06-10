# Diagnóstico: Tool Calling en Llama 3.1 8B con Continue.dev

## Problema Observado

El agente Llama 3.1 8B en Continue.dev NO está haciendo tool calls:
- El agente solo genera **descripciones** de lo que debería hacer
- No lee archivos usando las herramientas MCP disponibles  
- No modifica archivos
- No usa `convert_to_markdown` para leer PDFs/archivos

**Ejemplo:** Cuando se pide leer e integrar contenido, el agente responde:
```
"El código proporcionado es un ejemplo de cómo integrar...
Para implementar este cambio, necesitarás editar el archivo..."
```

En lugar de realmente ejecutar las acciones.

## Configuración Actual

**config.yaml** (líneas 7-20):
```yaml
- name: Llama 3.1 8B (Agent)
  provider: ollama
  model: llama3.1:8b
  apiBase: http://localhost:11434
  capabilities:
    - tool_use
  defaultCompletionOptions:
    contextLength: 32768
```

**MCP Server** (líneas 71-77):
```yaml
mcpServers:
  - name: markitdown
    command: C:\Users\Glade\.local\bin\uvx.exe
    args:
      - --with
      - markitdown[pdf]
      - markitdown-mcp
```

## Causas Probables (en orden de probabilidad)

### 1. **Continue.dev no está pasando las tool definitions a Ollama** ⚠️ MÁS PROBABLE

**Síntoma:** El agente nunca reconoce que tiene herramientas disponibles.

**Por qué:** 
- Continue.dev 1.2.22 puede tener un bug donde no envía las tool definitions en el formato que Ollama espera
- O Ollama 0.30.7 no soporta el protocolo de tool calling de Continue.dev

**Verificar:**
```bash
# Revisar en Continue.dev dev console qué parámetros se envían a Ollama
# (F1 > Developer: Toggle Developer Tools > Console)
```

**Solución:**
- Actualizar Continue.dev a la versión más reciente
- O actualizar Ollama a 0.40.0+
- O usar Codestral en lugar de Llama 3.1 8B para agentes

---

### 2. **Llama 3.1 8B en Ollama no realmente soporta tool calling**

**Síntoma:** El agente nunca usa las herramientas aunque estén disponibles.

**Por qué:**
- Ollama puede anunciar soporte para `tool_use` pero la implementación es limitada
- Llama 3.1 fue entrenado para tool calling pero puede no funcionar correctamente en Ollama

**Verificar:**
- Probar directamente con la API de Ollama:
```bash
curl http://localhost:11434/api/chat \
  -d '{"model":"llama3.1:8b", "tools": [...], ...}'
```
- Si el modelo no retorna `tool_calls` en la respuesta → no soporta

**Solución:**
- Usar Codestral (que sabemos funciona) para agentes
- Reservar Llama 3.1 8B para chat/edición (no agentes)

---

### 3. **contextLength 32768 es insuficiente o no se está aplicando**

**Síntoma:** Las tool definitions se truncan, el modelo no las ve.

**Por qué:**
- 32768 tokens puede no ser suficiente si incluye el prompt + contexto del proyecto + tool definitions
- Continue.dev podría no estar pasando correctamente `contextLength` a Ollama

**Verificar:**
- Preguntar al agente: "¿Cuál es tu contextLength?" 
- Si responde <8192 → problema confirmado

**Solución:**
- Aumentar a 40000-50000 (si el modelo lo soporta)
- O usar un modelo más capaz (Codestral)

---

### 4. **El prompt o modelo prefiere descripciones sobre acciones**

**Síntoma:** El agente entiende que tiene herramientas pero elige no usarlas.

**Por qué:**
- El temperature 0.2 es bajo pero el modelo aún puede preferir texto
- Llama 3.1 puede haber sido fine-tuned para ser "auxiliar" en lugar de "ejecutor"

**Solución:**
- Cambiar `temperature: 0.2` → `temperature: 0.5-0.7` (más exploración)
- O simplemente usar Codestral, que está optimizado para agentes

---

## Investigación: Pasos Siguientes

1. **Ejecutar el PROMPT_DIAGNOSTICO_TOOL_CALLING.txt** en VS Code
   - Esto nos dirá directamente si el agente "ve" las herramientas
   - Esto nos dirá cuál es el contextLength real del modelo

2. **Test directo de Ollama API**
   ```bash
   # Si esto funciona, Ollama soporta tools
   curl http://localhost:11434/api/chat \
     -d '{...payload con tools...}'
   # Buscar en la respuesta: "tool_calls" o "tool_use"
   ```

3. **Probar con Codestral**
   - Cambiar agente a Codestral y re-ejecutar el prompt mejorado
   - Si funciona con Codestral → Llama 3.1 8B es el problema
   - Si no funciona → el problema es Continue.dev o la configuración

4. **Revisar logs de Continue.dev**
   - F1 > Developer: Toggle Developer Tools
   - Pestaña Console/Network
   - Buscar requests a `http://localhost:11434`
   - Verificar si incluyen `tools` en el payload

---

## Recomendación Inmediata

Dado que:
- ✅ MCP markitdown funciona  
- ✅ Config.yaml está bien
- ✅ Ollama está corriendo
- ❌ Tool calling no funciona

**Opción recomendada:** 

Cambiar Llama 3.1 8B de agente a Codestral temporalmente:
```yaml
# En config.yaml, cambiar:
- name: Llama 3.1 8B (Agent)
  # roles:
  #   - chat  # ← COMENTAR
  #   - edit
  #   - apply
  #   - summarize
  # capabilities:
  #   - tool_use

- name: Codestral (Agent)  # ← ESTA LÍNEA SUBE COMO AGENTE PRIMARIO
  provider: ollama
  model: codestral:latest
  capabilities:
    - tool_use
  roles:
    - chat
    - edit
    - apply
    # - summarize
```

Esto permitirá probar si:
- Codestral hace tool calls → Llama 3.1 es el problema
- Codestral también falla → el problema es Continue.dev/Ollama

---

## Resumen

| Causa | Probabilidad | Prueba | Solución |
|-------|-------------|--------|----------|
| Continue.dev no envía tools a Ollama | 40% | Dev console inspect | Actualizar software |
| Llama 3.1 no soporta tool calling | 40% | Curl directo a API | Usar Codestral |
| contextLength insuficiente | 15% | Preguntar al agente | Aumentar o usar Codestral |
| Prompt prefiere descripción | 5% | Cambiar temperature | Usar Codestral |
