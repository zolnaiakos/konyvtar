import pool from '../data/db.js'
import { Router } from 'express'

const router = Router()

router.get('/:id/kolcsonzesek', async (req, res) => {

    const { id } = req.params;

    const [olvaso] = await pool.query(
        'SELECT * FROM olvasok WHERE id = ?',
        [id]
    );

    if (olvaso.length === 0) {
        return res.status(404).json({
            uzenet: 'Olvasó nem található!'
        });
    }

    const [kolcsonzesek] = await pool.query(`
        SELECT
            ko.*,
            k.cim AS konyvCim
        FROM kolcsonzesek ko
        JOIN konyvek k ON k.id = ko.konyvId
        WHERE ko.olvasoId = ?
    `, [id]);

    res.json({
        olvaso: olvaso[0].nev,
        kolcsonzesek: kolcsonzesek
    });
});

export default router