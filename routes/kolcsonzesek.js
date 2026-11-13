import pool from '../data/db.js'
import { Router } from 'express'

const router = Router()

router.get('/', async(req,res)=>{
   let sql = 'SELECT * FROM kolcsonzesek';

   if (req.query.aktiv === 'true') {
    sql = "SELECT * FROM kolcsonzesek WHERE visszahozva = 'false'";
}

    const [kolcsonzesek] = await pool.query(sql);

    let konyvC = 'SELECT id, cim FROM konyvek';
    const [konyvcim] = await pool.query(konyvC);

    let olvasoN = 'SELECT id, nev FROM olvasok';
    const [olvasonev] = await pool.query(olvasoN);

    let plusz = kolcsonzesek.map(kolcsonzes => {

        const konyv = konyvcim.find(
            k => k.id === kolcsonzes.konyvek_id
        );

        const olvaso = olvasonev.find(
            o => o.id === kolcsonzes.olvasok_id
        );

        return {
            ...kolcsonzes,
            konyvCim: konyv?.cim,
            olvasoNev: olvaso?.nev
        };
    });

    res.json(plusz);
 
})

router.post('/', async (req, res) => {
    //Ai segítségével készült post
    const { konyvId, olvasoId } = req.body;

    if (
        !Number.isInteger(konyvId) || konyvId <= 0 ||
        !Number.isInteger(olvasoId) || olvasoId <= 0
    ) {
        return res.status(400).json({
            uzenet: 'Hibás id'
        });
    }

    const [konyv] = await pool.query(
        'SELECT * FROM konyvek WHERE id = ?',
        [konyvId]
    );

    if (konyv.length === 0) {
        return res.status(404).json({
            uzenet: 'A könyv nem található!'
        });
    }

    const [olvaso] = await pool.query(
        'SELECT * FROM olvasok WHERE id = ?',
        [olvasoId]
    );

    if (olvaso.length === 0) {
        return res.status(404).json({
            uzenet: 'Az olvasó nem található!'
        });
    }

    const [aktiv] = await pool.query(
        "SELECT * FROM kolcsonzesek WHERE konyvId = ? AND visszahozva = 'false'",
        [konyvId]
    );

    if (aktiv.length > 0) {
        return res.status(409).json({
            uzenet: 'Ez a könyv ki van kölcsönözve'
        });
    }

    const [beszuras] = await pool.query(
        `INSERT INTO kolcsonzesek
        (konyvId, olvasoId, datum, visszahozva)
        VALUES (?, ?, CURDATE(), 'false')`,
        [konyvId, olvasoId]
    );

    const [ujKolcsonzes] = await pool.query(`
        SELECT
            k.*,
            ko.cim AS konyvCim,
            o.nev AS olvasoNev
        FROM kolcsonzesek k
        JOIN konyvek ko ON ko.id = k.konyvId
        JOIN olvasok o ON o.id = k.olvasoId
        WHERE k.id = ?
    `, [beszuras.insertId]);

    res.status(201).json(ujKolcsonzes[0]);
});

router.patch('/:id/visszahoz', async (req, res) => {
    //Ai segítségével készült
    const { id } = req.params;

    if (!Number.isInteger(Number(id)) || Number(id) <= 0) {
        return res.status(400).json({
            uzenet: 'Hibás kölcsönzésazonosító'
        });
    }

    const [kolcsonzes] = await pool.query(
        'SELECT * FROM kolcsonzesek WHERE id = ?',
        [id]
    );

    if (kolcsonzes.length === 0) {
        return res.status(404).json({
            uzenet: 'A kölcsönzés nem található'
        });
    }

    if (kolcsonzes[0].visszahozva === 'true') {
        return res.status(409).json({
            uzenet: 'Ezt a könyvet már visszahozták'
        });
    }

    await pool.query(
        `UPDATE kolcsonzesek
         SET visszahozva = 'true',
             visszahozasDatum = CURDATE()
         WHERE id = ?`,
        [id]
    );

    res.json({
        uzenet: 'A könyv visszahozása sikeres'
    });
});

export default router