package com.matteoperotta.taskflow

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.tooling.preview.Preview
import com.matteoperotta.taskflow.ui.theme.TaskFlowTheme

// Card per un singolo task (stateless)

@Composable
fun TaskCard(
    task: Task,
    onCardClick: () -> Unit,
    onToggleDone: () -> Unit
) {

    Card(
        onClick = onCardClick,
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {

        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {

            Column(
                modifier = Modifier.weight(1f)
            ) {

                // Titolo barrato se completato
                Text(
                    text = task.title,
                    style = MaterialTheme.typography.titleMedium,
                    textDecoration =
                        if (task.isDone)
                            TextDecoration.LineThrough
                        else
                            null
                )

                // Etichetta priorità
                Text(
                    text = task.priority.label,
                    style = MaterialTheme.typography.labelSmall,
                    color = task.priority.color
                )
            }

            // Icona check/clear cliccabile
            Icon(
                imageVector =
                    if (task.isDone)
                        Icons.Default.CheckCircle
                    else
                        Icons.Default.Clear,

                contentDescription = null,

                modifier = Modifier
                    .size(28.dp)
                    .clickable { onToggleDone() },

                tint =
                    if (task.isDone)
                        MaterialTheme.colorScheme.primary
                    else
                        MaterialTheme.colorScheme.outline
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun TaskCardPreview() {
    TaskFlowTheme {
        TaskCard(
            task = Task(
                title = "Finire Poképrezzi 🚀",
                priority = Priority.HIGH,
                isCompleted = false
            ),
            onCardClick = {},
            onToggleDone = {}
        )
    }
}
